#!/bin/bash

if [[ -z "${KDE_PATH}" ]]; then
    KDE_PATH=$(dirname $(readlink -f "$0"))
    cd ${KDE_PATH}
fi

source kde.env

undeploy(){
    local PROJECT_PATH=$1
    local PROJECT=$(basename $PROJECT_PATH)
    source ${PROJECT_PATH}/project.env

    docker run --rm -it \
    --net ${DOCKER_NETWORK} \
    --workdir ${KDE_PATH} \
    --env-file ${KDE_PATH}/kde.env \
    --env-file ${PROJECT_PATH}/project.env \
    --env-file ${PROJECT_PATH}/deploy.env \
    -e PROJECT=${PROJECT} \
    -e KUBECONFIG=${KDE_PATH}/${KUBE_CONFIG} \
    -v ${KDE_PATH}:${KDE_PATH} \
    -v ${KDE_PATH}/${KUBE_CONFIG}:${KDE_PATH}/${KUBE_CONFIG} \
    ${DEPLOY_ENV_IMAGE} \
    bash -c "${PROJECT_PATH}/undeploy.sh"
}

if [[ -n "$1" ]]; then
    project_path=${KDE_PATH}/${PROJECTS_DIR}/$1
    if [[ -d "$project_path" ]] && [[ ! -f "$project_path/.ignore" ]]; then
        # undeploy specific project
        undeploy $project_path
    fi
else
    # undeploy all projects
    for project_path in ${KDE_PATH}/${PROJECTS_DIR}/*; do
        if [[ -d "$project_path" ]] && [[ ! -f "$project_path/.ignore" ]]; then
            undeploy $project_path
        fi
    done
fi

