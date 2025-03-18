#!/bin/bash

if [[ -z "${KDE_PATH}" ]]; then
    KDE_PATH=$(dirname $(readlink -f "$0"))
    cd ${KDE_PATH}
fi

source kde.env

# 啟動 project.env 內設定的 init image 環境
exec-env(){
    local PROJECT=$1
    local PROJECT_PATH=${KDE_PATH}/${PROJECTS_DIR}/${PROJECT}
    
    if [[ -d "${PROJECT_PATH}" ]] && [[ ! -f "${PROJECT_PATH}/.ignore" ]]; then
        # exec specific project env
        source ${PROJECT_PATH}/project.env
        local SOURCE_CODE_DIR=$(basename -s .git ${GIT_REPO_URL})
        local WORKDIR=/usr/src/app
        mkdir -p ${KDE_PATH}/.npm
        mkdir -p ${KDE_PATH}/.cache

        docker run --rm -it \
        --platform linux/amd64 \
        --net ${DOCKER_NETWORK} \
        --workdir ${WORKDIR} \
        --user $UID:$(id -g) \
        --env-file ${KDE_PATH}/kde.env \
        --env-file ${PROJECT_PATH}/project.env \
        -e KDE_PATH=${KDE_PATH} \
        -e DEVELOPER_USER_ID=$UID \
        -e DEVELOPER_USER=$USER \
        -e PROJECT=${PROJECT} \
        -v ${KDE_PATH}/.npm:/.npm \
        -v ${KDE_PATH}/.cache:/.cache \
        -v ${KDE_PATH}/${VOLUME_DIR}/${PROJECT}/${SOURCE_CODE_DIR}:${WORKDIR} \
        ${INIT_ENV_IMAGE} \
        bash || sh
    else
        echo "此專案目前不存在或已設定 .ignore 忽略"
        exit 1
    fi
}

if [[ -n "$1" ]]; then
    exec-env $1
else
    read -p "請輸入專案名稱： " PROJECT
    exec-env ${PROJECT}
fi

