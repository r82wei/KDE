#!/bin/bash

if [[ -z "${KDE_PATH}" ]]; then
    KDE_PATH=$(dirname $(readlink -f "$0"))
    cd ${KDE_PATH}
fi

source kde.env

# stop k8s
source stop.sh

read -p "確定要移除設定檔？ (Y/n): " REMOVE_CONFIG

if [[ "${REMOVE_CONFIG}" == "Y" ]]; then
    if [[ -f "kind-config.yaml" ]]; then
        rm ${KDE_PATH}/kind-config.yaml
        echo "Remove kind-config.yaml"
    fi
    if [[ -f "kde.env" ]]; then
        rm ${KDE_PATH}/kde.env
        echo "Remove kde.env"
    fi
    for project_file_path in ${KDE_PATH}/${PROJECTS_DIR}/*/*; do
        if [[ -f "$project_file_path" && ( "${project_file_path##*/}" == "deploy.env" || "${project_file_path##*/}" == ".ignore" ) ]]; then
            rm $project_file_path
            echo "Remove ${project_file_path}"
        fi
    done
fi

read -p "是否要移除 Volume 資料夾 ${KDE_PATH}/${VOLUME_DIR}？ (Y/n): " REMOVE_VOLUME

if [[ "${REMOVE_VOLUME}" == "Y" ]]; then
    if [[ -d "${KDE_PATH}/${VOLUME_DIR}" ]]; then
        rm -rf ${KDE_PATH}/${VOLUME_DIR}
        echo "Remove ${KDE_PATH}/${VOLUME_DIR}"
    fi
fi