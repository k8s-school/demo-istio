#!/bin/bash

# Install Istio
# Check https://istio.io/docs/setup/getting-started/

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)
. "$DIR"/env.sh

NS="istio-system"

echo "Download istio (version $ISTIO_VERSION)"
if [ ! -d "$ISTIO_DIR" ]; then
    cd "$ISTIO_PARENT_DIR"
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION="$ISTIO_VERSION" sh -
fi

istioctl install -y --set profile=demo
kubectl get svc -n "$NS"

# Install dashboard (kiali, prometheus, grafana)
# kubectl apply -f "$DIR/crd.fixme.yaml"
kubectl apply -f "$ISTIO_DIR"/samples/addons
kubectl rollout status deployment/kiali -n "$NS"
