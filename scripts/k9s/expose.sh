#!/bin/bash


K9S_PORT=$1

docker run --rm -it --net ${DOCKER_NETWORK} -v ${KUBECONFIG}:/root/.kube/config -p "${K9S_PORT}":"${K9S_PORT}" quay.io/derailed/k9s -A