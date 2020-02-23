#!/bin/bash

set -euxo pipefail

DIR=$(cd "$(dirname "$0")"; pwd -P)

"$DIR"/istio-install.sh
"$DIR"/bookinfo-install.sh
"$DIR"/bookinfo-query-loop.sh -L 1
"$DIR"/port-forward.sh
"$DIR"/istio-uninstall.sh
