#!/usr/local/bin/dumb-init /bin/bash

export HOST=${ADV_HOST:-localhost}
if [ "X$(echo ${DOCKER_HOST} |egrep -o "tcp://")" != "X" ];then
   export DOCKER_HOST=$(echo ${DOCKER_HOST} |sed 's#tcp://##')
fi
npm start
