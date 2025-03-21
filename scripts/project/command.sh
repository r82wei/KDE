#!/bin/bash

source ${KDE_SCRIPTS_PATH}/utils/project.sh

# 定義顯示說明的函數
show_help() {
    echo "usage:"
    echo "  kde project <command> <project_name> [option]  專案相關指令"
    echo ""
    echo "option:"
    echo "  list, ls        列出專案"
    echo "  create          建立專案"
    echo "  link            連結專案"
    echo "  fetch           透過 git url 抓取專案"
    echo "  deploy          部署專案"
    echo "  undeploy        卸載專案"
    echo "  redeploy        重新部署專案"
    echo "  remove, rm      刪除專案"
    echo "  exec            進入專案"
}

show_exec_help() {
    echo "usage:"
    echo "  kde project exec <project_name> [option]  進入專案相關環境 container"
    echo ""
    echo "option:"
    echo "  runtime, run        進入專案 RUNTIME_IMAGE 啟動的 container (default)"
    echo "  deploy, dep         進入專案 DEPLOY_IMAGE 啟動的 container"
}

show_fetch_help() {
    echo "usage:"
    echo "  kde project fetch <project_name> <git repo url> <git repo branch>  從 git 直接抓取 KDE 專案"
}

check_project_name() {
    if [[ -z "${PROJECT_NAME}" ]]; then
        read -p "請輸入專案名稱: " PROJECT_NAME
    fi
}


exit_if_env_not_running ${CUR_ENV}

COMMAND=$1
PROJECT_NAME=$2

if [[ -z "${COMMAND}" ]]; then
    show_help
    exit 1
fi



case "${COMMAND}" in
    ls|list)
        ls ${ENVIORMENTS_PATH}/${CUR_ENV}/${VOLUMES_DIR}
        exit 0
        ;;
    create)
        check_project_name
        create_project ${PROJECT_NAME}
        ;;
    link)
        check_project_name
        create_link ${PROJECT_NAME}
        ;;
    fetch)
        PROJECT_GIT_REPO_URL=$3
        PROJECT_GIT_REPO_BRANCH=$4
        if [[ -z "${PROJECT_GIT_REPO_URL}" || -z "${PROJECT_GIT_REPO_BRANCH}" ]]; then
            show_fetch_help
            exit 1
        fi
        fetch_project ${PROJECT_NAME} ${PROJECT_GIT_REPO_URL} ${PROJECT_GIT_REPO_BRANCH}
        ;;
    deploy)
        check_project_name
        deploy_project ${PROJECT_NAME}
        ;;
    undeploy)
        check_project_name
        undeploy_project ${PROJECT_NAME}
        ;;
    redeploy)
        check_project_name
        undeploy_project ${PROJECT_NAME}
        deploy_project ${PROJECT_NAME}
        ;;
    remove|rm)
        check_project_name
        remove_project ${PROJECT_NAME}
        ;;
    exec)
        check_project_name
        IMAGE_TYPE=$3
        if [[ "${IMAGE_TYPE}" == "-h" || "${IMAGE_TYPE}" == "--help" ]]; then
            show_exec_help
            exit 1
        fi
        case "${IMAGE_TYPE}" in
            deploy|dep)
                exec_project_deploy_container ${PROJECT_NAME}
                ;;
            runtime|run|"")
                exec_project_runtime_container ${PROJECT_NAME}
                ;;
            *)
                show_exec_help
                exit 1
                ;;
        esac
        ;;
    *)
        echo "不支援的指令: $1"
        show_help
        exit 1
        ;;
esac