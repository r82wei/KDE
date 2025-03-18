FROM ubuntu:22.04

ARG TARGETOS
ARG TARGETARCH
ARG KIND_VERSION

RUN apt-get update
RUN apt-get install -y \
    ca-certificates \
    curl \
    gnupg
RUN mkdir -m 0755 -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "${VERSION_CODENAME}")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
# 偵測系統架構並下載對應的 kind
RUN curl -Lo /usr/local/bin/kind \
  "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-${TARGETOS}-${TARGETARCH}" \
  && chmod +x /usr/local/bin/kind