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

# Binary to use for checksum.
SUM_BIN=sha1sum

function use_beta() {
    DLPATH=www.ssl-proxy.info:/var/www/sslproxy/julia-download/beta
    DLPATHWEB=https://juliahilfe.allgeier-it.de/julia-download/beta
}

#
# Download latest julia 3.6 image.
#
function get_image() {
    get_sha1

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

function clean_download() {
    rm -f julia-3.6-64bit212-install-feature4
}

# No image, load it.
if [ ! -f "$IMAGE_NAME" ] || [ ! -f "$SHA1_NAME" ] ; then
    echo "No image found, downloading image."
    get_image
fi

# Compare SHA-1
echo "Checking SHA"
$SUM_BIN --check $SHA_NAME
if [ $? != 0 ]; then
    echo "Checksum does not match, downloading latest julia image."
    clean_download
    use_beta
    get_image
else
    echo "Done, image is up-to-date. :)"
    print_patchlevel
    exit 0
fi

echo "Now checking SHA again"
$SUM_BIN --check $SHA_NAME
if [ $? != 0 ]; then
    echo "ERROR: Downloaded latest image, but checksum does still not match :("
    clean_download
    exit 1
fi

print_patchlevel
echo "Done :)"

# EOF
