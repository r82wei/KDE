#!/bin/bash


FORMAT_SCRIPT='--no-headers -o custom-columns=":metadata.name"'

# 取得 Namespace 名稱
namespaces=($(get_namespaces))

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

# 選擇要 Port forward 的服務類型(Service/Pod)
while true; do
    echo "請選擇要 Port forward 的服務類型："
    echo "1) Service"
    echo "2) Pod"
    echo "3) 退出"

    read -p "輸入選項編號: " SERVICE_TYPE

    case "$SERVICE_TYPE" in
    1)
        export SERVICE_TYPE=service
        break
        ;;
    2)
        export SERVICE_TYPE=pod
        break
        ;;
    3)
        echo "退出程式"
        exit 0
        ;;
    *)
        echo "無效的選項，請重新輸入！"
        ;;
    esac
done


# 取得 Service/Pod 名稱並存入陣列
services=($(get_services ${TARGET_NAMESPACE}))
# 檢查是否存在
if [ ${#services[@]} -eq 0 ]; then
  echo "Namespace: ${TARGET_NAMESPACE} 目前沒有任何 ${SERVICE_TYPE} 存在。"
  exit 1
fi

# 顯示選單
PS3="請選擇服務名稱（輸入編號）："
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
            echo "你選擇了 ${SERVICE_TYPE}: $service"
            read -p "請輸入服務 port: " TARGET_PORT
            read -p "請輸入本地 port: " LOCAL_PORT
            exec_port_forward ${TARGET_NAMESPACE} ${SERVICE_TYPE} ${service} ${TARGET_PORT} ${LOCAL_PORT}
            break
            ;;
    esac
done
