#!/bin/bash

# Links a directory $1 to /opt/julia/var/ + basename $1.
function check_dir() {
    local __dir=$1
    if [ -L "$__dir" ]; then
        echo "Directory $__dir already linked."
        return
    fi
    echo "Directory $__dir not linked."
    
    local __moved_dir="/opt/julia/var/"$(basename $__dir)

    echo "Checking existence of $__moved_dir."

    if [ ! -d "$__moved_dir"  ]; then
        echo "Moved dir $__moved_dir does not exist. Do nothing."
        return
    fi

    # Moved directory does exist, link it.
    rm -rf $__dir
    if [ "$?" != "0" ]; then
        echo "Unable to delete directory $__dir."
        exit 1
    fi

    echo "Linking $__moved_dir to $__dir"
    ln -s $__moved_dir $__dir
    if [ "$?" != "0" ]; then
        echo "Error linking $__moved_dir $__dir."
        exit 1
    fi

    return
}

function check_ssh_dir() {
    if [ ! -d "/opt/julia/var/.ssh" ]; then
        echo "Directory /opt/julia/var/.ssh does not exist, do nothing."
        return
    fi

    echo "Copy .ssh from var to /opt/julia."
    cp -pr /opt/julia/var/.ssh /opt/julia/
}

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM

#check_dir /opt/julia/jup
#check_dir /opt/julia/etc
check_ssh_dir

# Set node
echo "Setting /opt/julia/etc/local-node to $HOSTNAME"
echo "LOCAL_NODE_SERVER=$HOSTNAME" > /opt/julia/etc/local-node
echo "LOCAL_NODE_PORT=22" >> /opt/julia/etc/local-node

# Set rights before starting any servce.
/opt/julia/sbin/julia-set-rights /opt/julia

# Start services

if [ $START_SSHD == "yes" ]; then
    /usr/sbin/sshd
fi

# start service in background here
if [ $START_HTTPD == "yes" ]; then
    rm -f /opt/julia/apache/logs/httpd.pid
    /opt/julia/sbin/webinterface start
fi

if [ $START_POSTFIX == "yes" ]; then
    cd /opt/julia/etc/postfix-in
    /opt/julia/sbin/postmap transport
    /opt/julia/sbin/postmap access
    
    /opt/julia/sbin/postfix start
fi

if [ $START_JWATCHDOG == "yes" ]; then
    /opt/julia/bin/jwatchdog /opt/julia start
fi

if [ $START_EMILY == "yes" ]; then
    /opt/julia/sbin/emily /opt/julia start
fi

echo -n "doing: sleep infinity"
sleep infinity

#
# stop service and clean up here
#

echo "stopping apache"
if [ $START_HTTPD == "yes" ]; then
    /opt/julia/sbin/webinterface stop
fi

if [ $START_POSTFIX == "yes" ]; then
    /opt/julia/sbin/postfix stop
fi

if [ $START_JWATCHDOG == "yes" ]; then
    /opt/julia/bin/jwatchdog /opt/julia stop
fi

if [ $START_EMILY == "yes" ]; then
    /opt/julia/sbin/emily /opt/julia stop
fi

echo "exited $0"
