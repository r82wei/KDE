#!/bin/bash

read -p "請輸入 kind 版本 (default: v0.27.0)： " KIND_VERSION
KIND_VERSION=${KIND_VERSION:-v0.27.0}

echo "Build kind ${KIND_VERSION} image ..."
docker buildx build --platform linux/amd64,linux/arm64 --push --build-arg KIND_VERSION=${KIND_VERSION} -f kind.Dockerfile -t r82wei/kind:${KIND_VERSION} .