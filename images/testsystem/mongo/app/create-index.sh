#!/bin/bash
#
# Script to create indexes in MongoDB
#
#

# change into folder of this script
cd ${0%/*}

# MongoDB options for TLS usage
MONGO_OPTS="--ssl --sslAllowInvalidHostnames --sslCAFile /etc/mongodb.ca.pem"
MONGODB_LOG_COLLECTION="julialog"

MONGO_DIR=/app/js

cat $MONGO_DIR/index.js > $MONGO_DIR/index_active.js
if [ $? != "0" ]; then
	echo "Error creating index."
	exit 1
fi

# no auth
mongosh 127.0.0.1:27017/juliadb $MONGO_OPTS $MONGO_DIR/index_active.js
if [ $? != "0" ]; then
	echo "Error creating index."
	exit 1
fi

echo "--------------------------------------------------"
echo "Index creation complete."
echo "--------------------------------------------------"
