#!/bin/bash

docker run --rm -it --net ${DOCKER_NETWORK} -v ${KUBECONFIG}:/root/.kube/config quay.io/derailed/k9s -A