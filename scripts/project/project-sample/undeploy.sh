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

### 掛載路徑 ###
# /project: projects 底下的 [project] 資料夾
# /volume: volume 底下的 [project] 資料夾



### 設定環境解除部署步驟 ###

# e.g.
# helm uninstall [project]

# e.g.
# kubectl delete namespace [namespace]

echo "Undeploy ${PROJECT} ..."

