#!/bin/bash

set -e
source $(dirname $0)/00-init-env.sh

# To prevent any taken ports from script n°20, we stop all containers
docker stop $(docker ps -a -q)

#-------------------------------------------------------------------------------
# Start docker container
#-------------------------------------------------------------------------------
if [ -d "$JHI_FOLDER_APP"/docker-compose ]; then
    cd "$JHI_FOLDER_APP"/docker-compose
    if [ -a docker-compose.yml ]; then
        docker-compose up -d
    fi
fi

docker ps -a