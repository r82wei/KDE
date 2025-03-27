#!/bin/bash

# 定義顯示說明的函數
show_help() {
    echo "usage:"
    echo "  kde k8s restart <name> [option]  重啟 k8s 環境"
    echo "option:"
    echo "  -f, --force  強制關閉 k8s 環境"
}

if [[ $1 == "--help" || $1 == "-h" ]]; then
    show_help
    exit 0
fi

# 檢查環境是否存在
exit_if_env_not_exist ${1:-${CUR_ENV}}

# 關閉環境
kde stop ${1:-${CUR_ENV}} $2

# 啟動環境
kde start ${1:-${CUR_ENV}}