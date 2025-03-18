#!/bin/bash

echo "Build deploy-env image ..."
docker buildx build --platform linux/amd64,linux/arm64 --push -f Dockerfile -t r82wei/deploy-env:1.0.0 .