#!/bin/bash

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
    -n ingress-nginx --create-namespace \
    --wait \
    --set controller.service.type=NodePort \
    --set controller.config.enable-access-log=true \
    --set controller.service.nodePorts.http=30080 \
    --set controller.service.nodePorts.https=30443