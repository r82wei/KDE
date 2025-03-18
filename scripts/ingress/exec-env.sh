#!/bin/bash


# 將 ~ 轉換成 $HOME
export KUBECONFIG=$(echo "${KDE_PATH}/${KUBE_CONFIG}" | sed "s|~|$HOME|")

read -p "請輸入本地要掛載的資料夾名稱 (e.g. test-volume)： " TARGET_MOUNT_DIR

docker run --rm -it \
--net ${DOCKER_NETWORK} \
--workdir /tmp \
--user $UID:$(id -g) \
-v ${KDE_PATH}/${KUBE_CONFIG}:${KDE_PATH}/${KUBE_CONFIG} \
-v ${KDE_PATH}/scripts/mount-dir/mount-dir.sh:/tmp/mount-dir.sh \
--env-file ${KDE_PATH}/kde.env \
-e TARGET_MOUNT_DIR=${TARGET_MOUNT_DIR} \
-e KUBECONFIG=${KDE_PATH}/${KUBE_CONFIG} \
-e STORAGE_CLASS=${STORAGE_CLASS} \
r82wei/deploy-env:1.0.0 \
bash -c "/tmp/mount-dir.sh"