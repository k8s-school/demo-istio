#!/bin/bash

echo -e "\e[1;32mBOOKINFO URL\e[0m"
echo -e "\e[1;32m-----------------\e[0m"

# See https://istio.io/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports

set -euxo pipefail

NODE1=$(kubectl get nodes --selector="! node-role.kubernetes.io/master" \
    -o=jsonpath='{.items[0].metadata.name}')

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export INGRESS_HOST=$(kubectl get nodes "$NODE1" -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
GATEWAY_URL="http://$INGRESS_HOST:$INGRESS_PORT/productpage"

echo "$GATEWAY_URL"
