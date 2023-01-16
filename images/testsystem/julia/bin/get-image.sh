#!/usr/bin/env bash
#
# Simple script to download latest julia installer image from download
# server.
#
#

if [ -z "$1" ]; then
    echo "Usage: $0 VERSION <BASIC-AUTH>"
    echo "When BASIC-AUTH is empty, SSH is used."
    exit 1
fi

# Version to download. this is julias patchlevel name.
VERSION=$1
BASIC_AUTH=$2
USE_SCP="false"

if [ -z "$2" ]; then
    USE_SCP="true"
fi

echo "Using scp: $USE_SCP"

SSH_USER=$USER

# For ralf ;)
if [ "$SSH_USER" == "rn" ]; then
    SSH_USER=ralf
fi

IMG_NAME=julia-3.6-64bit212-install-$VERSION.tar.gz
SHA_NAME=julia-3.6-64bit212-install-$VERSION-sha1.txt

# Official release path.
DLPATH=www.ssl-proxy.info:/var/www/sslproxy/julia-download/releases
DLPATHWEB=https://juliahilfe.allgeier-it.de/julia-download/releases

# Download from beta, if requested as latest.
if [ "$VERSION" == "latest" ]; then
    DLPATH=www.ssl-proxy.info:/var/www/sslproxy/julia-download/beta
    USE_SCP="true"

    IMG_NAME=`ssh $SSH_USER@www.ssl-proxy.info ls /var/www/sslproxy/julia-download/beta/julia-3.6-64bit212-install-*.tar.gz`
    if [ $? != "0" ]; then
        echo "Error getting image name."
        exit 1
    fi

    IMG_NAME=`basename $IMG_NAME`
    
    SHA_NAME=`ssh $SSH_USER@www.ssl-proxy.info ls /var/www/sslproxy/julia-download/beta/julia-3.6-64bit212-install-*-sha1.txt`
    if [ $? != "0" ]; then
        echo "Error getting image sha 1 name."
        exit 1
    fi

    SHA_NAME=`basename $SHA_NAME`
fi

#
# Download latest julia 3.6 image.
#
function get_image() {
    if [ "$USE_SCP" == "true" ]; then
        scp $SSH_USER@$DLPATH/$IMG_NAME .
    else
        curl -u "$BASIC_AUTH" \
            $DLPATHWEB/$IMG_NAME \
            --output $IMG_NAME
    fi

    if [ $? != 0 ]; then
        echo "Error loading image."
        exit 1
    fi
}

function get_sha1() {
    if [ "$USE_SCP" == "true" ]; then
        scp $SSH_USER@$DLPATH/$SHA_NAME .
    else
        curl -u $BASIC_AUTH \
            $DLPATHWEB/$SHA_NAME \
            --output $SHA_NAME
    fi

    if [ $? != 0 ]; then
        echo "Error loading image SHA-1 checksum."
        exit 1
    fi
}

function print_patchlevel() {
    local l=`echo $SHA_NAME | awk -F '-' '{ print $5 }'`
    echo "PATCHLEVEL:$l"
}

# First download sha1, always.
get_sha1

IMAGE_NAME=`ls $IMG_NAME`
SHA1_NAME=`ls $SHA_NAME`

# No image, load it.
if [ ! -f "$IMAGE_NAME" ]; then
    echo "No image found, downloading image."
    get_image
fi

echo "Image: $IMAGE_NAME"
echo "SHA-1: $SHA1_NAME"

# Compare SHA-1
echo "Checking SHA-1"
sha1sum --check $SHA1_NAME
if [ $? != 0 ]; then
    echo "SHA-1 checksum does not match, downloading latest julia image."
    get_image
else
    echo "Done, image is up-to-date. :)"
    print_patchlevel
    exit 0
fi

echo "Now checking SHA-1 again"
sha1sum --check $SHA1_NAME
if [ $? != 0 ]; then
    echo "ERROR: Downloaded latest image, but SHA-1 does still not match :("
    exit 1
fi

print_patchlevel
echo "Done :)"

# EOF
