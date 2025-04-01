#!/bin/bash

echo "Build ngrok-proxy image ..."
docker buildx build --platform linux/amd64,linux/arm64 --push --build-arg KUBECTL_VERSION=${KUBECTL_VERSION} -f Dockerfile -t r82wei/ngrok-proxy:1.0.0 .