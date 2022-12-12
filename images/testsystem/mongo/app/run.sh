#!/bin/bash

# Things to do on start.
/app/onstart.sh &

# Start MongoDB.
gosu mongodb mongod --dbpath=/data/db --bind_ip_all --config /etc/mongod.conf



