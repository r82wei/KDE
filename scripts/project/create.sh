#!/bin/bash

if [[ -z "${KDE_PATH}" ]]; then
    KDE_PATH=$(dirname $(readlink -f "$0"))
    cd ${KDE_PATH}
fi

touch kde.env
source kde.env

if [[ -z "${PROJECTS_DIR}" ]]; then
    PROJECTS_DIR=projects
    echo "PROJECTS_DIR=${PROJECTS_DIR}" >> kde.env
fi

if [[ -z "${VOLUME_DIR}" ]]; then
    VOLUME_DIR=volume
    echo "VOLUME_DIR=${VOLUME_DIR}" >> kde.env
    mkdir -p ${KDE_PATH}/${VOLUME_DIR}
fi

# 輸入 Project 名稱
while [ -z "${PROJECT}" ]; do
  read -p "請輸入 Project 名稱: " PROJECT
  PROJECT_PATH="${KDE_PATH}/${PROJECTS_DIR}/${PROJECT}"
  if [ -d "${PROJECT_PATH}" ]; then
    echo "資料夾 '${PROJECT_PATH}' 已存在，請重新輸入。"
    PROJECT=""
  fi
done

# 新增 Project 資料夾及初始檔案
mkdir -p ${PROJECT_PATH}
cp ${KDE_PATH}/lib/project-sample/* ${PROJECT_PATH}/
touch ${PROJECT_PATH}/deploy.env

# 新增 Project volume namespace 資料夾
PROJECT_VOLUME_PATH="${KDE_PATH}/${VOLUME_DIR}/${PROJECT}"
mkdir -p ${PROJECT_VOLUME_PATH}

# 新增 Project 設定
PROJECT_ENV=${PROJECT_PATH}/project.env
touch ${PROJECT_ENV}

# git pull
read -p "請輸入 git repo HTTPS URL: " GIT_REPO_URL
echo "GIT_REPO_URL=${GIT_REPO_URL}" >> ${PROJECT_ENV}
read -p "請輸入分支名稱(default: main): " GIT_REPO_BRANCH
GIT_REPO_BRANCH="${GIT_REPO_BRANCH:-main}"
echo "GIT_REPO_BRANCH=${GIT_REPO_BRANCH}" >> ${PROJECT_ENV}
git clone --recursive -b ${GIT_REPO_BRANCH} ${GIT_REPO_URL} ${KDE_PATH}/${VOLUME_DIR}/${PROJECT}/$(basename -s .git ${GIT_REPO_URL})

# 設定專案初始化 base image
while [ -z "${INIT_ENV_IMAGE}" ]; do
  read -p "請輸入 ${PROJECT} 執行初始化的環境 image: " INIT_ENV_IMAGE
  if [ ! -z "${INIT_ENV_IMAGE}" ]; then
    echo "INIT_ENV_IMAGE=${INIT_ENV_IMAGE}" >> ${PROJECT_ENV}
  fi
done

# 設定專案部署 base image
while [ -z "${DEPLOY_ENV_IMAGE}" ]; do
  read -p "請輸入 ${PROJECT} 執行部署的環境 image: " DEPLOY_ENV_IMAGE
  if [ ! -z "${DEPLOY_ENV_IMAGE}" ]; then
    echo "DEPLOY_ENV_IMAGE=${DEPLOY_ENV_IMAGE}" >> ${PROJECT_ENV}
  fi
done

echo "Project ${PROJECT} 新增完成，請到 ${PROJECT_PATH} 修改初始化及部署腳本"