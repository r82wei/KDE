#!/bin/bash

if [[ -z "${KDE_PATH}" ]]; then
    KDE_PATH=$(dirname $(readlink -f "$0"))
    cd ${KDE_PATH}
fi

source kde.env

init(){
    local PROJECT_PATH=$1
    local PROJECT=$(basename $PROJECT_PATH)
    touch ${PROJECT_PATH}/deploy.env
    source ${PROJECT_PATH}/project.env
    mkdir -p ${KDE_PATH}/.npm
    mkdir -p ${KDE_PATH}/.cache
    
    docker run --rm -it \
    --platform linux/amd64 \
    --net ${DOCKER_NETWORK} \
    --workdir ${KDE_PATH} \
    --user $UID:$(id -g) \
    --env-file ${KDE_PATH}/kde.env \
    --env-file ${PROJECT_PATH}/project.env \
    --env-file ${PROJECT_PATH}/deploy.env \
    -e KDE_PATH=${KDE_PATH} \
    -e DEVELOPER_USER_ID=$UID \
    -e DEVELOPER_USER=$USER \
    -e PROJECT=${PROJECT} \
    -v ${KDE_PATH}/.npm:/.npm \
    -v ${KDE_PATH}/.cache:/.cache \
    -v ${KDE_PATH}:${KDE_PATH} \
    ${INIT_ENV_IMAGE} \
    bash -c "${PROJECT_PATH}/init.sh"
}

deploy(){
    local PROJECT_PATH=$1
    local PROJECT=$(basename $PROJECT_PATH)
    source ${PROJECT_PATH}/project.env
    
    docker run --rm -it \
    --net ${DOCKER_NETWORK} \
    --workdir ${KDE_PATH} \
    --env-file ${KDE_PATH}/kde.env \
    --env-file ${PROJECT_PATH}/project.env \
    --env-file ${PROJECT_PATH}/deploy.env \
    -e KDE_PATH=${KDE_PATH} \
    -e DEVELOPER_USER_ID=$UID \
    -e DEVELOPER_USER=$USER \
    -e PROJECT=${PROJECT} \
    -e KUBECONFIG=${KDE_PATH}/${KUBE_CONFIG} \
    -v ${KDE_PATH}:${KDE_PATH} \
    -v ${KDE_PATH}/${KUBE_CONFIG}:${KDE_PATH}/${KUBE_CONFIG} \
    ${DEPLOY_ENV_IMAGE} \
    bash -c "${PROJECT_PATH}/deploy.sh"
}

if [[ -z "${PROJECTS_DIR}" ]]; then
    PROJECTS_DIR=projects
    echo "PROJECTS_DIR=${PROJECTS_DIR}" >> kde.env
fi

if [[ -n "$1" ]]; then
    project_path=${KDE_PATH}/${PROJECTS_DIR}/$1
    if [[ -d "$project_path" ]] && [[ ! -f "$project_path/.ignore" ]]; then
        # init specific project
        init $project_path
        # deploy specific project
        deploy $project_path
    fi
else
    # deploy all projects
    for project_path in ${KDE_PATH}/${PROJECTS_DIR}/*; do
        if [[ -d "$project_path" ]] && [[ ! -f "$project_path/.ignore" ]]; then
            # init specific project
            init $project_path
            # deploy specific project
            deploy $project_path
        fi
    done
fi

