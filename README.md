[<img src="http://k8s-school.fr/images/logo.svg" alt="K8s-school Logo, expertise et formation Kubernetes" height="50" />](https://k8s-school.fr)

[![Build Status](https://travis-ci.com/k8s-school/istio-example.svg?branch=master)](https://travis-ci.com/k8s-school/istio-example)

Based on official [Istio Getting Started page](https://istio.io/latest/docs/setup/getting-started/)

# Pre-requisites

An account on an up and running k8s cluster, for example [kind](https://travis-ci.com/k8s-school/kind-travis-ci)

# Install Istio and its Dashboards

```shell
git clone https://github.com/k8s-school/istio-example
cd istio-example
./istio-install.sh

# Access to istio dashboards for prometheus, jaeger, kiali 
./start-ui.sh
```

# Install Bookinfo demo application
 
```shell
./bookinfo-install.sh

# Launch a few queries through ingress gateway
./bookinfo-query-loop.sh -L 10000

# Display Bookinfo external url
./bookinfo-url.sh

# Tune Istio L7 load-balancing for Bookinfo application
./traffic-management.sh
```


