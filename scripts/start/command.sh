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


# 初始化環境變數
init_env ${1:-${CUR_ENV}} ${2:-kind}

# 根據第一個參數來選擇不同的處理流程
case "$2" in
    --help|-h)
        show_help
        exit 0
        ;;
    k3d)
        echo "啟動 k3d 環境"
        source scripts/start/k3s/init.sh
        ;;
    *)
        echo "啟動 kind 環境"
        source scripts/start/kind/init.sh
        ;;
esac