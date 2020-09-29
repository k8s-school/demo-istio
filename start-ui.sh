#!/bin/bash

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)
. "$DIR"/env.sh

istioctl dashboard kiali 
istioctl dashboard jaeger
istioctl dashboard prometheus
