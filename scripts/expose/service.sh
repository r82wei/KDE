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

# 取得 Services 名稱並存入陣列
services=($(kubectl -n ${TARGET_NAMESPACE} get services --no-headers -o custom-columns=":metadata.name"))
echo $services
# 檢查是否有 service 存在
if [ ${#services[@]} -eq 0 ]; then
  echo "目前沒有任何 Service 存在。"
  exit 1
fi

# 顯示選單
PS3="請選擇一個 Service（輸入編號）："

select service in "${services[@]}" "退出"
do
    case $service in
        "退出")
            echo "退出"
            exit 0
            ;;
        "")
            echo "無效選擇，請重新輸入。"
            ;;
        *)
            echo "你選擇了 Service：$service"
            read -p "請輸入 Service 要轉發的 port: " TARGET_PORT
            kubectl -n ${TARGET_NAMESPACE} port-forward --address 0.0.0.0 svc/$service ${LOCAL_PORT}:${TARGET_PORT}
            break
            ;;
    esac
done
