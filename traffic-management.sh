#!/bin/bash

# See https://istio.io/docs/tasks/traffic-management/request-routing/

set -euo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)
. "$DIR"/env.sh

ISTIO_DIR="$DIR/istio-${ISTIO_VERSION}"

wait_key()
{
  echo "Press 'c' to continue"
  count=0
  while : ; do
	  read -n 1 k <&1
	  if [[ $k = c ]] ; then
		  printf "\nContinuing\n"
		  break
	  else
		  ((count=$count+1))
		  printf "\nIterate for $count times\n"
                  echo "Press 'c' to continue"
	  fi
  done
}

echo "Route all traffic to v1 services, see http://localhost:20001/kiali"
set -x
kubectl apply -f "$ISTIO_DIR"/samples/bookinfo/networking/destination-rule-all.yaml
kubectl get destinationrules -o yaml
kubectl apply -f "$ISTIO_DIR"/samples/bookinfo/networking/virtual-service-all-v1.yaml
kubectl get virtualservices -o yaml
# Example below works fine
# kubectl apply -f "$ISTIO_DIR"/samples/bookinfo/networking/virtual-service-reviews-v3.yaml

set +x
echo -e "\e[1;32mRoute all traffic to v1 services, see kiali\e[0m"
wait_key

echo "Route 50% traffic to v3 services"
set -x
kubectl apply -f "$ISTIO_DIR"/samples/bookinfo/networking/virtual-service-reviews-50-v3.yaml
set +x
echo -e "\e[1;32mRoute 50% traffic to v3 services, see kiali\e[0m"
wait_key

echo "Route based on user identity"
set -x
kubectl apply -f "$ISTIO_DIR"/samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml
kubectl get virtualservice reviews -o yaml
set +x
echo -e "\e[1;32mRoute traffic using user identity\e[0m"
echo "On the /productpage of the Bookinfo app, log in as user jason."
wait_key

echo "Clean up"
set -x
kubectl delete -f "$ISTIO_DIR"/samples/bookinfo/networking/virtual-service-all-v1.yaml
set +x

