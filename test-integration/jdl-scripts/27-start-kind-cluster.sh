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
# kind create cluster
# export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

# kubectl cluster-info

#-------------------------------------------------------------------------------
# Starting local cluster
#-------------------------------------------------------------------------------
sudo microk8s.start
microk8s.kubectl cluster-info