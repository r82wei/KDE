#!/bin/bash

check_ngrok_token() {
    CUR_ENV=$1
    load_enviroment_env ${CUR_ENV}
    if [[ -z "${NGROK_TOKEN}" ]]; then
        read -p "請輸入 NGROK_TOKEN: " NGROK_TOKEN
        echo "NGROK_TOKEN=${NGROK_TOKEN}" >> ${KDE_ENVIRONMENTS_PATH}/${CUR_ENV}/.env
    fi
}

if_ngrok_container_exist() {
    CUR_ENV=$1
    CONTAINER_NAME=kde-ngrok-${CUR_ENV}
    if docker ps -a | grep -q ${CONTAINER_NAME}; then
        echo "true"
    else
        echo "false"
    fi
}

ngrok_http() {
    CUR_ENV=$1
    CONTAINER_NAME=kde-ngrok-${CUR_ENV}

    check_ngrok_token ${CUR_ENV}
    # 啟動 ngrok
    docker run -it --rm --name ${CONTAINER_NAME} -e NGROK_AUTHTOKEN=${NGROK_TOKEN} --network ${DOCKER_NETWORK} ngrok/ngrok:latest http http://${K8S_CONTAINER_NAME}:30080
}

ngrok_http_daemon() {
    CUR_ENV=$1
    CONTAINER_NAME=kde-ngrok-${CUR_ENV}
    
    check_ngrok_token ${CUR_ENV}
    # 啟動 ngrok TODO: 無法在背景啟動(Fix)
    if [[ $(if_ngrok_container_exist ${CUR_ENV}) == "false" ]]; then
        docker run -it -d --name ${CONTAINER_NAME} -e NGROK_DEBUG="true" -e NGROK_AUTHTOKEN=${NGROK_TOKEN} --network ${DOCKER_NETWORK} ngrok/ngrok:latest http http://${K8S_CONTAINER_NAME}:30080
    fi
    docker logs -f ${CONTAINER_NAME}
}
