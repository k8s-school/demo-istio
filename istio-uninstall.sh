#!/bin/bash

# Uninstall Istio
# Check https://istio.io/docs/setup/getting-started/#uninstall

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)
. "$DIR"/env.sh

kubectl delete -f "$ISTIO_DIR"/samples/addons --ignore-not-found=true
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system
