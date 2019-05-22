#!/bin/bash

set -e
source $(dirname $0)/00-init-env.sh

#-------------------------------------------------------------------------------
# Stopping docker containers
#-------------------------------------------------------------------------------
# docker stop $(docker ps -a)
# docker rm $(docker ps -a -q)

#-------------------------------------------------------------------------------
# Starting local cluster
#-------------------------------------------------------------------------------
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
kind create cluster