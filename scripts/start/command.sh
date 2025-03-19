#!/bin/bash

# 定義顯示說明的函數
show_help() {
    echo "usage:"
    echo "  kde start <name> [option]  啟動 k8s 環境"
    echo ""
    echo "option:"
    echo "  kind           啟動 kind 環境 (預設)"
    echo "  k3d            啟動 k3d 環境"
}

# 安裝 k8s 預設常用的服務
install_default_services() {
    script=$(< ${KDE_PATH}/scripts/start/install-default-services.sh)
    exec_script_in_deploy_env_with_tty "${script}"
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
    exit 0
fi

# 初始化環境變數
init_env ${1:-${CUR_ENV}} ${2:-kind}

# 設定預設環境
set_default_env ${1:-${CUR_ENV}}

# 根據第一個參數來選擇不同的處理流程
case "$2" in
    k3d)
        echo "啟動 k3d 環境"
        source scripts/start/k3d/init.sh
        install_default_services
        ;;
    *)
        echo "啟動 kind 環境"
        source scripts/start/kind/init.sh
        install_default_services
        ;;
esac