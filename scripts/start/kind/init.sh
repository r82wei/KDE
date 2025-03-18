#!/bin/bash

###### Init K8S ######
# 檢查同名 K8S 叢集是否存在
if docker ps -a --format '{{.Names}}' | grep -qw ${K8S_CONTAINER_NAME}; then
    echo "K8S named '${K8S_CONTAINER_NAME}' exists."
else
    if [[ ! -f "${ENV_PATH}/kind-config.yaml" ]]; then
        envsubst < ${KDE_PATH}/scripts/start/kind/kind-config.template.yaml > ${ENV_PATH}/kind-config.yaml
    fi

    # Ensure Docker network
    if [ -z "$( docker network ls | awk '{print $2}' | grep ^$DOCKER_NETWORK$ )" ]; then
        docker network create $DOCKER_NETWORK
    fi
    
    # Install K8S
    docker run \
    --rm \
    -it \
    --net $DOCKER_NETWORK \
    -e KIND_EXPERIMENTAL_DOCKER_NETWORK=${DOCKER_NETWORK} \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ${ENV_PATH}/kubeconfig:/root/.kube \
    -v ${ENV_PATH}/kind-config.yaml:/config.yaml \
    r82wei/kind:v0.27.0 \
    sh -c "kind create cluster --config=/config.yaml && sed "s/0.0.0.0:[0-9]*/$K8S_CONTAINER_NAME:6443/ig" ~/.kube/config > ~/.kube/config.new && mv ~/.kube/config.new ~/.kube/config"

    if [ $? -ne 0 ]; then
        echo "kind 初始化失敗"
        exit 1
    fi

    # Install local-path-storage & ingress nginx
    exec_script_in_deploy_env_with_kde "./scripts/start/install-local-path-storage.sh && ./scripts/start/helm-install-ingress.sh"

fi

echo "K8S 初始化已完成"
###### Init K8S ######
