#!/usr/bin/env bash


JULIA_PREFIX=/opt/julia
UPDATE_FILE=$JULIA_PREFIX/var/cfg-update.tar.gz

if [ ! -f $UPDATE_FILE  ]; then
    echo "Update file $UPDATE_FILE does not exist, do nothing."
    exit 0
fi

cd $JULIA_PREFIX
if [ "$?" != "0" ]; then
    echo "Unable to change dir to $JULIA_PREFIX"
    exit 1
fi

echo "Update file found, extracting to $JULIA_PREFIX"
echo "----------------------------------------------------------"
tar xzvf $UPDATE_FILE
if [ "$?" != "0" ]; then
    echo "tar returned error, can't go on."
    exit 1
fi
echo "----------------------------------------------------------"

rm -f $UPDATE_FILE
if [ "$?" != "0" ]; then
    echo "can't remove update file, can't go on."
    exit 1
fi

echo "done."
