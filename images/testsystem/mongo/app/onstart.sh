#!/bin/bash
#
#

# Wait for MongoDB to come up.
RET=1
while [[ "$RET" -ne 0 ]]; do
    echo "Waiting for MongoDB to start..."
    mongosh admin --eval "help" > /dev/null 2>&1
    RET=$?
    sleep 2
done

# Create indexes.
/app/create-index.sh
