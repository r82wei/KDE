FROM alpine:latest

ARG TARGETOS
ARG TARGETARCH
ARG K3D_VERSION

# 安裝 docker-cli
RUN apk add --no-cache docker curl bash
# 安裝 k3d
RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=${K3D_VERSION} bash