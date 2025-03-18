#!/bin/bash

# 定義顯示說明的函數
show_help() {
    echo "usage:"
    echo "  kde k8s stop <name> [option]  關閉 k8s 環境"
    echo ""
    echo "option:"
    echo "  -f, --force  強制關閉 k8s 環境"
}

if [[ $1 == "--help" || $1 == "-h" ]]; then
    show_help
    exit 0
fi

# 關閉環境
stop_env ${1:-${CUR_ENV}} $2