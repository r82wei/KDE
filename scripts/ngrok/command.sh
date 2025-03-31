#!/bin/bash

source ${KDE_SCRIPTS_PATH}/utils/ngrok.sh

# 定義顯示說明的函數
show_help() {
    echo "usage:"
    echo "  kde ngrok 透過 Ngrok 建立連線"
    echo ""
    echo "option:"
    echo "  daemon, -d          在背景執行"
}

OPTION=$1

case "${OPTION}" in
    "")
        exit_if_env_not_exist ${CUR_ENV}
        ngrok_http ${CUR_ENV}
        ;;
    "daemon" | "-d")
        exit_if_env_not_exist ${CUR_ENV}
        ngrok_http_daemon ${CUR_ENV}
        ;;
    *)
        echo "不支援的選項: $1"
        show_help
        exit 1
        ;;
esac