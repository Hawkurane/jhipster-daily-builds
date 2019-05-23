#!/bin/bash

source $(dirname $0)/00-init-env.sh

#-------------------------------------------------------------------------------
# Connecting to cluster
#-------------------------------------------------------------------------------
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

ip=$(kubectl get nodes -o wide | grep master | awk '{print $6; }')
port=$(kubectl get service -n jhipster | grep LoadBalancer | awk '{print $5; }' | cut -d ':' -f2 | cut -d '/' -f1)
httpUrl="http://$(ip):$(port)"
echo "HTTP URL = "
echo httpUrl

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
launchCurlOrProtractor() {
    retryCount=1
    maxRetry=30

    ip=$(kubectl get nodes -o wide | grep master | awk '{print $6; }')
    port=$(kubectl get service -n jhipster | grep LoadBalancer | awk '{print $5; }' | cut -d ':' -f2 | cut -d '/' -f1)
    httpUrl="http://$(ip):$(port)"

    rep=$(curl -v "$httpUrl")
    status=$?
    while [ "$status" -ne 0 ] && [ "$retryCount" -le "$maxRetry" ]; do
        echo "*** [$(date)] Application not reachable yet. Sleep and retry - retryCount =" $retryCount "/" $maxRetry
        retryCount=$((retryCount+1))
        sleep 10
        rep=$(curl -v "$httpUrl")
        status=$?
    done

    if [ "$status" -ne 0 ]; then
        echo "*** [$(date)] Not connected after" $retryCount " retries."
        return 1
    fi

    if [ "$JHI_PROTRACTOR" != 1 ]; then
        return 0
    fi

    retryCount=0
    maxRetry=1
    until [ "$retryCount" -ge "$maxRetry" ]
    do
        result=0
        if [[ -f "tsconfig.json" ]]; then
            npm run e2e
        fi
        result=$?
        [ $result -eq 0 ] && break
        retryCount=$((retryCount+1))
        echo "*** e2e tests failed... retryCount =" $retryCount "/" $maxRetry
        sleep 15
    done
    return $result
}

#-------------------------------------------------------------------------------
# Run the application
#-------------------------------------------------------------------------------
if [ "$JHI_RUN_APP" == 1 ]; then
    # After the script 24 (deploy with docker compose), the app should be already up
    launchCurlOrProtractor
fi