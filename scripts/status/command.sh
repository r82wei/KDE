#!/bin/bash

# 查詢 enviorments 底下每個資料夾的 .env ，並且將查出的 K8S_CONTAINER_NAME 存成陣列
K8S_CONTAINER_NAMES=$(grep -r "K8S_CONTAINER_NAME" ${ENVIORMENTS_PATH}/*/.env | awk -F= '{print $2}')
# echo "${K8S_CONTAINER_NAMES[@]}"

# 構建 docker ps 的 filter 參數
FILTERS=""
for NAME in ${K8S_CONTAINER_NAMES[@]}; do
    FILTERS+="--filter name=${NAME} "
done

# 透過 docker ps 查看 K8S_CONTAINER_NAMES 內的多個 container 狀態，並且儲存成字串
RUNNING_STATUS=$(docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.ID}}" $FILTERS)

# 將 K8S_CONTAINER_NAMES 內沒有在 STATUS 內的 container 狀態設為 "未啟動" 並且加入 STATUS 字串
for NAME in ${K8S_CONTAINER_NAMES[@]}; do
    if ! echo "${RUNNING_STATUS}" | grep -q "${NAME}"; then
        UNRUNNING_STATUS="${UNRUNNING_STATUS}${NAME}\t未啟動\n"
    fi
done

echo "${RUNNING_STATUS}"
echo "--------------------------------"
echo -e "${UNRUNNING_STATUS}"