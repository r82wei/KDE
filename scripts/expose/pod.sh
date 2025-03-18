#!/bin/bash

# 取得 Namespace 名稱並存入陣列
TARGET_NAMESPACE=""
namespaces=($(kubectl get namespace --no-headers -o custom-columns=":metadata.name"))
echo $namespaces
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

# 取得 Pod 名稱並存入陣列
pods=($(kubectl -n ${TARGET_NAMESPACE} get pods --no-headers -o custom-columns=":metadata.name"))
echo $pods
# 檢查是否有 pod 存在
if [ ${#pods[@]} -eq 0 ]; then
  echo "目前沒有任何 Pod 存在。"
  exit 1
fi

# 顯示選單
PS3="請選擇一個 Pod（輸入編號）："

select pod in "${pods[@]}" "退出"
do
    case $pod in
        "退出")
            echo "退出"
            exit 0
            ;;
        "")
            echo "無效選擇，請重新輸入。"
            ;;
        *)
            echo "你選擇了 Pod：$pod"
            read -p "請輸入 Pod 要轉發的 port: " TARGET_PORT
            kubectl -n ${TARGET_NAMESPACE} port-forward --address 0.0.0.0 $pod ${LOCAL_PORT}:${TARGET_PORT}
            break
            ;;
    esac
done
