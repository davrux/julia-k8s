#!/usr/bin/env bash
#
# Loads a TGZ from an external source via rclone.
#


JULIA_PREFIX=/opt/julia
UPDATE_FILE=$JULIA_PREFIX/var/cfg-update.tar.gz

VERSION_FILE=/config/config-version
CONFIG_FILE=/config/config.cfg
RCLONE_CONFIG_FILE=/config/rclone.conf

# Config file must exist.
if [ ! -f $CONFIG_FILE ]; then
    echo "File $CONFIG_FILE does not exist, do nothing."
    exit 0
fi

# Version file must exist.
if [ ! -f $VERSION_FILE ]; then
    echo "File $VERSION_FILE does not exist, do nothing."
    exit 0
fi
VERSION=$(cat $VERSION_FILE)
VERSION_TGZ=$VERSION.tar.gz


# Read in config.
source /config/config.cfg

if [ "$USE_RCLONE" != "true" ]; then
    echo "rclone disabled."
    exit 0
fi

echo "Using rclone for syncing."

VERSION=$(cat /config/config-version)

rclone --config $RCLONE_CONFIG_FILE $ADDITIONAL_RCLONE_OPTIONS copyto $RCLONE_CLOUD_STORE/$VERSION_TGZ $UPDATE_FILE
if [ "$?" != "0" ]; then
    echo "rclone returned error, can't go on."
    exit 1
fi

if [ ! -f $UPDATE_FILE ]; then
    echo "No update file loaded from cloud."
    exit 0
fi

# TODO: Check signature and/or sha256 sum.

echo "Successfully loaded $VERSION_TGZ to $UPDATE_FILE via rclone."
