#!/bin/bash

### 可用環境變數 ###
# env file 內的環境變數
#  - kde.env
#  - ${KDE_PATH}/projects/[project]/project.env
#  - ${KDE_PATH}/projects/[project]/deploy.env
# KDE_PATH: quick-start kind 資料夾路徑
# PROJECT: 專案名稱
# DEVELOPER_USER: 當前執行使用者的名稱
# DEVELOPER_USER_ID: 當前執行使用者的 UID
# KUBECONFIG: kubeconfig 路徑

### 設定環境部署步驟 ###

# e.g.
# helm upgrade [project] .helm \
# --install \
# -f values.yaml

# e.g.
# kubectl apply -f [project yaml]

echo "Deploy ${PROJECT} ..."

