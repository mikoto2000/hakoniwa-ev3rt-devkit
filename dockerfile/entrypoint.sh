#!/bin/bash

export DOCKER_HOST=$(dig host.docker.internal +short)

sed -i -e "s/127\.0\.0\.1/${DOCKER_HOST}/g" /ev3rt-athrill-v850e2m/sdk/common/device_config.txt
echo "DEBUG_FUNC_VDEV_RX_IPADDR 0.0.0.0" >> /ev3rt-athrill-v850e2m/sdk/common/device_config.txt

bash -c "$*"

