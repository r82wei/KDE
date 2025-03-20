#!/bin/bash

# 定義顯示說明的函數
show_help() {
    echo "usage:"
    echo "  kde expose [namespace] [pod|service] [target port] [local port]         將 port forward 到本地端"
    echo ""
    echo "option:"
    echo "  -h, --help           顯示說明"
}

if [[ $1 == "--help" || $1 == "-h" ]]; then
    show_help
    exit 0
fi

exit_if_env_not_running ${ENV_NAME}

NAMESPACE=$1
RESOURCE_TYPE=$(echo $2 | tr '[:upper:]' '[:lower:]')
RESOURCE_NAME=$3
TARGET_PORT=$4
LOCAL_PORT=$5

echo "Is namespace exist: $(is_namespace_exist ${NAMESPACE})"
echo "Is pod_or service exist: $(is_pod_or_service_exist ${NAMESPACE} ${RESOURCE_TYPE} ${RESOURCE_NAME})"
echo "Is pod exist: $(is_pod_exist ${NAMESPACE} ${RESOURCE_NAME})"
echo "Is service exist: $(is_service_exist ${NAMESPACE} ${RESOURCE_NAME})"
echo "Is target port valid: $(is_port_valid ${TARGET_PORT})"
echo "Is local port valid: $(is_port_valid ${LOCAL_PORT})"

if [[ $(is_namespace_exist ${NAMESPACE}) == "true" && $(is_pod_or_service_exist ${NAMESPACE} ${RESOURCE_TYPE} ${RESOURCE_NAME}) == "true" && $(is_port_valid ${TARGET_PORT}) == "true" && $(is_port_valid ${LOCAL_PORT}) == "true" ]]; then    
    echo "NAMESPACE: ${NAMESPACE}"
    echo "RESOURCE_TYPE: ${RESOURCE_TYPE}"
    echo "RESOURCE_NAME: ${RESOURCE_NAME}"
    echo "TARGET_PORT: ${TARGET_PORT}"
    echo "LOCAL_PORT: ${LOCAL_PORT}"
    exec_port_forward ${NAMESPACE} ${RESOURCE_TYPE} ${RESOURCE_NAME} ${TARGET_PORT} ${LOCAL_PORT}
else
    source ${KDE_SCRIPTS_PATH}/expose/hint.sh
fi
