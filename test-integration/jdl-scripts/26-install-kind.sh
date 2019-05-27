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
# Installing minikube
#-------------------------------------------------------------------------------
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
chmod +x minikube
sudo cp minikube /usr/local/bin && rm minikube