#!/bin/bash

echo -e "\e[1;32mQUERYING BOOKINFO\e[0m"
echo -e "\e[1;32m-----------------\e[0m"

LOOP_COUNT="10000"

usage() {
    cat << EOD

Usage: `basename $0` [options] [cmd]

  Available options:
    -L <loop_count>  Loop number for querying bookinfo application, default to $LOOP_COUNT

EOD
}


# get the options
while getopts L: c ; do
    case $c in
        L) LOOP_COUNT="$OPTARG" ;;
        \?) usage ; exit 2 ;;
    esac
done
shift $(($OPTIND - 1))


# See https://istio.io/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports

set -euxo pipefail

NODE1=$(kubectl get nodes --selector="! node-role.kubernetes.io/master" \
    -o=jsonpath='{.items[0].metadata.name}')

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=$(kubectl get nodes "$NODE1" -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
GATEWAY_URL="http://$INGRESS_HOST:$INGRESS_PORT/productpage"

LOG_FILE="/tmp/query.log"
rm -rf "$LOG_FILE"

echo "Sending logs to $LOG_FILE"

# TODO: test siege or fortio
curl -s "${GATEWAY_URL}"
kubectl get nodes -o wide
kubectl get svc
kubectl get pod
curl -s "${GATEWAY_URL}" | grep -o "<title>.*</title>" >> "$LOG_FILE"
curl  -sIv "${GATEWAY_URL}" >> "$LOG_FILE"

for i in {1..$LOOP_COUNT}; 
do echo "====================================" >> "$LOG_FILE"
  sleep 1
  for i in {1..100}; 
  do
    if ! curl -s "$GATEWAY_URL" | grep 'font color' | uniq >> "$LOG_FILE"
    then
        echo "No star found" >> "$LOG_FILE"
    fi
  done
done
