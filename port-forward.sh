#!/bin/bash

# Install Istio
# Check https://istio.io/docs/setup/getting-started/

set -euxo pipefail

NS="istio-system"

kubectl -n "$NS" port-forward $(kubectl -n "$NS" get pod -l app=kiali -o jsonpath='{.items[0].metadata.name}') 20001:20001 &
echo -e "\e[1;32mKiali access: http://localhost:20001\e[0m"

kubectl -n "$NS" port-forward $(kubectl -n "$NS" get pod -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 15032:16686 &
echo -e "\e[1;32mJaeger access: http://localhost:15032\e[0m"

kubectl -n "$NS" port-forward $(kubectl -n "$NS" get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 &
echo -e "\e[1;32mGrafana access: http://localhost:3000\e[0m"
