#!/bin/bash

set -e
source $(dirname $0)/00-init-env.sh


#-------------------------------------------------------------------------------
# Installing kind
#-------------------------------------------------------------------------------
# curl -Lo ./kind-linux-amd64 https://github.com/kubernetes-sigs/kind/releases/download/v0.3.0/kind-linux-amd64
# chmod +x ./kind-linux-amd64
# sudo mv ./kind-linux-amd64 /usr/local/bin/kind
# kind --version

#-------------------------------------------------------------------------------
# Installing kubectl
#-------------------------------------------------------------------------------
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# kubectl version

#-------------------------------------------------------------------------------
# Installing snap
#-------------------------------------------------------------------------------
sudo apt update
sudo apt install snapd

#-------------------------------------------------------------------------------
# Testing snap
#-------------------------------------------------------------------------------
sudo snap install hello-world
# hello-world

#-------------------------------------------------------------------------------
# Installing microk8s
#-------------------------------------------------------------------------------
sudo snap install microk8s --classic