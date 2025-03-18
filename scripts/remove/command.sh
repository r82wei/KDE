#!/bin/bash

# 定義顯示說明的函數
show_help() {
    echo "usage:"
    echo "  kde k8s remove <name>  刪除 k8s 環境"
}

# 如果沒有參數，顯示說明
if [[ -z "$1" ]]; then
    show_help
    exit 1
fi

export ENV_NAME=${1:-${CUR_ENV}}

# 檢查環境是否存在
exit_if_env_not_exist ${ENV_NAME}

# 刪除環境
remove_env ${ENV_NAME}