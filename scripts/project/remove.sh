#!/bin/bash

if [[ -z "${KDE_PATH}" ]]; then
    KDE_PATH=$(dirname $(readlink -f "$0"))
    cd ${KDE_PATH}
fi

source kde.env

remove(){
    local PROJECT=$1
    read -p "確定要刪除 ${PROJECT} ？ (Y/n): " DELETE
    if [[ "${DELETE}" == "Y" ]]; then
        PROJECT_PATH=${KDE_PATH}/${PROJECTS_DIR}/${PROJECT}
        if [[ -d ${PROJECT_PATH} ]]; then
            echo "Remove: ${PROJECT_PATH}"
            rm -r ${PROJECT_PATH}
        fi
        VOLUME_PATH=${KDE_PATH}/${VOLUME_DIR}/${PROJECT}
        if [[ -d ${VOLUME_PATH} ]]; then
            echo "Remove: ${VOLUME_PATH}"
            rm -r ${VOLUME_PATH}
        fi
    else
        echo "取消 (不做任何動作)"
    fi
}

if [[ -n "$1" ]]; then
    # remove specific project
    remove $1
else
    read -p "請輸入要刪除的 project : " PROJECT
    remove $PROJECT
fi

