#!/bin/bash

set -e
source $(dirname $0)/00-init-env.sh

cd "$JHI_FOLDER_APP/docker-compose"
if [ -a docker-compose.yml ]; then
    docker-compose up -d
fi
