#!/usr/bin/env bash
#
# Bootstrap init script for k8s.
#

cd /opt/julia

# First extract var.
tar xzf share/julia-tmpl/tmpl.tar.gz
if [ "$?" != "0" ]; then
    echo "Error extracting template tar"
    exit 1
fi

ln -f -s /opt/julia/var/etc /opt/julia/etc
ln -f -s /opt/julia/var/jup /opt/julia/jup

# Load cfg update, when available.
/app/load-cfg-update.sh
if [ "$?" != "0" ]; then
        echo "Error loading config update using load-cfg-update.sh."
        exit 1
fi

# Update config from tgz.
/app/cfg-update.sh
if [ "$?" != "0" ]; then
        echo "Error updating config using cfg-update.sh."
        exit 1
fi


/opt/julia/sbin/julia-set-rights /opt/julia

echo "done"
