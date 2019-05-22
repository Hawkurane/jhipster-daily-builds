#!/bin/bash

set -e
source $(dirname $0)/00-init-env.sh


#-------------------------------------------------------------------------------
# Installing kind
#-------------------------------------------------------------------------------
curl -Lo ./kind-linux-amd64 https://github.com/kubernetes-sigs/kind/releases/download/v0.3.0/kind-linux-amd64
chmod +x ./kind-linux-amd64
sudo mv ./kind-linux-amd64 /usr/local/bin/kind
kind --version