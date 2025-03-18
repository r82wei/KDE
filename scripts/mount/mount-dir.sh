#!/bin/bash

# 取得 Namespace 名稱並存入陣列
TARGET_NAMESPACE=""
namespaces=($(kubectl get namespace --no-headers -o custom-columns=":metadata.name"))

PS3="請選擇一個 Namespace（輸入編號）："
select namespace in "${namespaces[@]}" "退出"
do
    case $namespace in
        "退出")
            echo "退出"
            exit 0
            ;;
        "")
            echo "無效選擇，請重新輸入。"
            ;;
        *)
            echo "你選擇了 Namespace：$namespace"
            TARGET_NAMESPACE=$namespace
            break
            ;;
    esac
done

# 檢查 pvc 是否存在，如果不存在則新增
pvc=($(kubectl -n ${TARGET_NAMESPACE} get pvc ${TARGET_MOUNT_DIR} --no-headers -o custom-columns=":metadata.name"))
if [ -n $pvc ]; then
    # 新增本機資料夾
    VOLUME_PATH=${KDE_PATH}/${VOLUME_DIR}
    mkdir -p ${VOLUME_PATH}/${TARGET_NAMESPACE}/${TARGET_MOUNT_DIR}
    ls -lah ${VOLUME_PATH}/${TARGET_NAMESPACE}/${TARGET_MOUNT_DIR}
    echo "已新增本機資料夾 ${VOLUME_PATH}/${TARGET_NAMESPACE}/${TARGET_MOUNT_DIR}"

    # 新增 pvc
    echo "
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: ${TARGET_MOUNT_DIR}
      namespace: ${TARGET_NAMESPACE}
    spec:
      accessModes:
        - ReadWriteMany
      resources:
        requests:
          storage: 5Gi
      storageClassName: ${STORAGE_CLASS}
    " | kubectl apply -f - 

    if [ $? -eq 0 ]; then
        echo "已新增 pvc ${TARGET_MOUNT_DIR}"
    else 
        exit 1
    fi
fi

# 取得 deployment 名稱並存入陣列
deployments=($(kubectl -n ${TARGET_NAMESPACE} get deployments --no-headers -o custom-columns=":metadata.name"))
echo $deployments
# 檢查是否有 deployment 存在
if [ ${#deployments[@]} -eq 0 ]; then
    echo "目前沒有任何 Deployment 存在。"
    exit 1
fi

# 顯示選單
PS3="請選擇一個 Deployment（輸入編號）："
select deployment in "${deployments[@]}" "退出"
do
    case $deployment in
        "退出")
            echo "退出"
            exit 0
            ;;
        "")
            echo "無效選擇，請重新輸入。"
            ;;
        *)
            echo "你選擇了 Deployment：$deployment"
            TARGET_DEPLOYMENT=$deployment
            break
            ;;
    esac
done

# 選擇 container
containers=($(kubectl -n $TARGET_NAMESPACE get deployment ${TARGET_DEPLOYMENT} -o jsonpath='{.spec.template.spec.containers[*].name}'))
if [[ ${#containers[@]} -gt 1 ]]; then
    PS3="請選擇一個 Container（輸入編號）："
    select container in "${containers[@]}" "退出"
    do
        case $container in
            "退出")
                echo "退出"
                exit 0
                ;;
            "")
                echo "無效選擇，請重新輸入。"
                ;;
            *)
                echo "你選擇了 Container：$container"
                TARGET_CONTAINER=$container
                break
                ;;
        esac
    done
else
    TARGET_CONTAINER=${containers[0]}
fi


read -p "請輸入要掛載的路徑： " TARGET_MOUNT_PATH

kubectl -n $TARGET_NAMESPACE patch deployment $deployment -p "{\"spec\":{\"template\":{\"spec\":{\"volumes\":[{\"name\":\"${TARGET_MOUNT_DIR}\",\"persistentVolumeClaim\":{\"claimName\":\"${TARGET_MOUNT_DIR}\"}}], \"containers\": [{\"name\": \"${TARGET_CONTAINER}\", \"volumeMounts\":[{\"name\":\"${TARGET_MOUNT_DIR}\",\"mountPath\":\"${TARGET_MOUNT_PATH}\"}]}]}}}}"