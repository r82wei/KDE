#!/bin/bash

# 設定 KDE 根目錄路徑
export KDE_PATH=$PWD
# 設定環境目錄路徑(enviorments)
export ENVIORMENTS_PATH=${KDE_PATH}/enviorments
# 設定專案目錄路徑(projects)
export PROJECTS_PATH=${ENVIORMENTS_PATH}/projects
# 設定 KUBE_CONFIG_DIR
export KUBE_CONFIG_DIR=kubeconfig
# 設定 VOLUMES_DIR
export VOLUMES_DIR=volumes

source scripts/utils/enviorment.sh

# 設定當前環境的環境變數
if [[ -f ${KDE_PATH}/current.env ]]; then
    source ${KDE_PATH}/current.env
fi

if [[ $(is_env_exist ${CUR_ENV}) == "false" ]]; then
    echo "環境 ${CUR_ENV} 不存在"
    # 修改預設環境
    set_default_env
else
    load_enviorment_env ${CUR_ENV}
fi


# 定義顯示說明的函數
show_help() {
    echo "usage: kde <command>"
    echo ""
    echo "command:"
    echo "  ls              列出 k8s 環境"
    echo "  start           啟動 k8s 環境"
    echo "  stop            停止 k8s 環境"
    echo "  restart         重啟 k8s 環境"
    echo "  status          顯示 k8s 環境狀態"
    echo "  remove          移除 k8s 環境"
    echo "  current         顯示目前 k8s 環境名稱"
    echo "  k9s             進入 k9s dashboard"
    echo "  ingress         ingress 相關操作"
    echo "  mount           掛載目錄到指定的 Pod"
    echo "  expose          將 service/pod port forward 到本地指定的 port"
    echo "  exec            進入有部署相關工具的環境"
    echo "  reset           重置 kde 環境，清除 environments 和 projects 資料夾"
    echo "  project         project 管理"
}


# 根據第一個參數來選擇不同的處理流程
case "$1" in
    ls|list)
        ls ${ENVIORMENTS_PATH}
        ;;
    start)
        shift  # 移除 "start" 指令
        source scripts/start/command.sh
        ;;
    stop)
        shift  # 移除 "stop" 指令
        source scripts/stop/command.sh
        ;;
    restart)
        shift  # 移除 "restart" 指令
        source scripts/restart/command.sh
        ;;
    status)
        shift  # 移除 "status" 指令
        source scripts/status/command.sh
        ;;
    current)
        if [[ -z "${CUR_ENV}" ]]; then
            echo "目前沒有設定任何 k8s 環境"
        else
            echo "當前 k8s 環境名稱: ${CUR_ENV}"
        fi
        ;;
    default)
        shift  # 移除 "status" 指令
        set_default_env $1
        ;;
    remove)
        shift  # 移除 "remove" 指令
        source scripts/remove/command.sh
        ;;
    exec)
        shift  # 移除 "exec" 指令
        source scripts/exec/command.sh
        ;;
    ingress)
        shift  # 移除 "ingress" 指令
        echo "ingress 相關操作"
        source scripts/ingress/command.sh
        ;;
    mount)
        shift  # 移除 "mount" 指令
        echo "掛載目錄到指定的 Pod"
        source scripts/mount/command.sh
        ;;
    expose)
        shift  # 移除 "expose" 指令
        source scripts/expose/command.sh
        ;;
    k9s)
        shift  # 移除 "k9s" 指令
        source scripts/k9s/command.sh
        exit 0
        ;;
    project)
        shift  # 移除 "project"  指令
        source scripts/project/command.sh
        ;;
    reset)
        shift  # 移除 "reset" 指令
        source scripts/reset/command.sh
        exit 0
        ;;
    *)
        show_help
        exit 0
        ;;
esac
