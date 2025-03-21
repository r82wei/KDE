#!/bin/bash

is_project_exist() {
    if [[ ! -d ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/$1 ]]; then
        echo "false"
    else
        echo "true"
    fi
}

exit_if_project_exist() {
    if [[ $(is_project_exist $1) == "true" ]]; then
        echo "專案 ${1} 已存在"
        exit 1
    fi
}

exit_if_project_not_exist() {
    if [[ $(is_project_exist $1) == "false" ]]; then
        echo "專案 ${1} 不存在"
        exit 1
    fi
}

# 建立專案資料夾、namespace
create_project() {
    PROJECT_NAME=$1
    exit_if_project_exist ${PROJECT_NAME}
    mkdir -p ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}
    create_namespace ${PROJECT_NAME}
    set_git_repo ${PROJECT_NAME}
    source ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/project.env
    REPO_PATH=${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/$(git_repo_name ${GIT_REPO_URL})
    download_git_repo ${PROJECT_NAME} ${GIT_REPO_URL} ${GIT_REPO_BRANCH} ${REPO_PATH}
    read -p "請輸入專案執行(建置)環境 Image (執行 pre-deploy.sh 的環境): " RUNTIME_IMAGE
    echo "RUNTIME_IMAGE=${RUNTIME_IMAGE}" >> ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/project.env
    read -p "請輸入專案部署環境 Image (執行 deploy.sh 的環境): " DEPLOY_IMAGE
    echo "DEPLOY_IMAGE=${DEPLOY_IMAGE}" >> ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/project.env
    init_project_deploy_script ${PROJECT_NAME}
    echo "專案 ${PROJECT_NAME} 已建立"
}

fetch_project() {
    PROJECT_NAME=$1
    PROJECT_GIT_REPO_URL=$2
    PROJECT_GIT_REPO_BRANCH=$3
    create_namespace ${PROJECT_NAME}
    PROJECT_REPO_PATH=${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}
    download_git_repo ${PROJECT_NAME} ${PROJECT_GIT_REPO_URL} ${PROJECT_GIT_REPO_BRANCH} ${PROJECT_REPO_PATH}
    if [[ ! -f ${PROJECT_REPO_PATH}/project.env ]]; then
        echo "專案 ${PROJECT_NAME} 設定檔(project.env) 不存在"
        exit 1
    fi
    source ${PROJECT_REPO_PATH}/project.env
    download_git_repo ${PROJECT_NAME} ${GIT_REPO_URL} ${GIT_REPO_BRANCH} ${PROJECT_REPO_PATH}/$(git_repo_name ${GIT_REPO_URL})
}

init_project_deploy_script() {
    PROJECT_NAME=$1
    touch ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/pre-deploy.sh
    chmod +x ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/pre-deploy.sh
    touch ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/deploy.sh
    chmod +x ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/deploy.sh
    touch ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/post-deploy.sh
    chmod +x ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/post-deploy.sh
}

git_repo_name() {
    GIT_REPO_URL=$1
    echo $(basename -s .git ${GIT_REPO_URL})
}

set_git_repo() {
    PROJECT_NAME=$1
    exit_if_project_not_exist ${PROJECT_NAME}
    read -p "請輸入 git repo HTTPS URL: " GIT_REPO_URL
    echo "GIT_REPO_URL=${GIT_REPO_URL}" >> ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/project.env
    read -p "請輸入分支名稱(default: main): " GIT_REPO_BRANCH
    echo "GIT_REPO_BRANCH=${GIT_REPO_BRANCH}" >> ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/project.env
}

download_git_repo() {
    PROJECT_NAME=$1
    GIT_REPO_URL=$2
    GIT_REPO_BRANCH=$3
    REPO_PATH=$4

    if [[ -d ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/$(git_repo_name ${GIT_REPO_URL}) ]]; then
        rm -r ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/$(git_repo_name ${GIT_REPO_URL})
    fi

    # 下載 git repo
    git clone --recursive -b ${GIT_REPO_BRANCH} ${GIT_REPO_URL} ${REPO_PATH}
}

# 建立資料夾軟連結
create_link() {
    PROJECT_NAME=$1
    exit_if_project_not_exist ${PROJECT_NAME}
    read -p "請輸入資料夾路徑: " DIR_PATH
    if [[ ! -d ${DIR_PATH} ]]; then
        echo "資料夾 ${DIR_PATH} 不存在"
        exit 1
    fi
    # 透過資料夾路徑取得資料夾名稱
    DIR_NAME=$(basename ${DIR_PATH})
    ln -s ${DIR_PATH} ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/${DIR_NAME}
}

deploy_project() {
    PROJECT_NAME=$1
    exit_if_project_not_exist ${PROJECT_NAME}
    echo ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}
    source ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/project.env
    if [[ -f ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/pre-deploy.sh ]]; then
        exec_script_in_container_with_project ${PROJECT_NAME} ${RUNTIME_IMAGE} ./pre-deploy.sh
    fi
    if [[ -f ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/deploy.sh ]]; then
        exec_script_in_container_with_project ${PROJECT_NAME} ${DEPLOY_IMAGE} ./deploy.sh
    fi
    if [[ -f ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/post-deploy.sh ]]; then
        exec_script_in_container_with_project ${PROJECT_NAME} ${DEPLOY_IMAGE} ./post-deploy.sh
    fi
    echo "專案 ${PROJECT_NAME} 已部署完成"
}

undeploy_project() {
    PROJECT_NAME=$1
    exec_script_in_deploy_env "kubectl delete ns ${PROJECT_NAME}"
    echo "專案 ${PROJECT_NAME} 已解除部署"
}

remove_project() {
    PROJECT_NAME=$1
    exit_if_project_not_exist ${PROJECT_NAME}
    exec_script_in_deploy_env "kubectl delete ns ${PROJECT_NAME}"
    rm -rf ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}
    echo "專案 ${PROJECT_NAME} 已刪除"
}

exec_project_runtime_container() {
    PROJECT_NAME=$1
    exit_if_project_not_exist ${PROJECT_NAME}
    source ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/project.env
    REPO_NAME=$(git_repo_name ${GIT_REPO_URL})
    echo "REPO_NAME: ${REPO_NAME}"
    exec_script_in_container_with_project ${PROJECT_NAME} ${RUNTIME_IMAGE} "cd ${REPO_NAME} && bash"
}

exec_project_deploy_container() {
    PROJECT_NAME=$1
    exit_if_project_not_exist ${PROJECT_NAME}
    source ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}/${PROJECT_NAME}/project.env
    exec_script_in_container_with_project ${PROJECT_NAME} ${DEPLOY_IMAGE} bash
}
