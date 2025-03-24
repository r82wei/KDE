# Kubernetes Development Environment(KDE)

## 安裝說明

- 環境需求

  - docker

- 執行 `install.sh` 安裝
  - 將 `kde.sh` & `scripts/` 安裝到 `~/.kde` 中
  - 將 `kde.sh` 設定為 alias `kde` 並且加入 `~/.bash_aliases` 或 `~/.zshrc` 中
  - 執行完 `install.sh` 後需要重啟終端機，才可以使用 `kde` 指令
  ```
  ./install.sh
  ```
- 執行 `upgrade.sh` 升級
  - 更新 `~/.kde` 的 `kde.sh` & `scripts/`
  ```
  ./upgrade.sh
  ```

## 使用說明

- 執行 `kde` 查看使用說明

  ```
  kde
  ```

  ```
  usage: kde <command>

  command:
    list, ls                            列出 k8s 環境
    start, create <env_name> [--k3d]    啟動 k8s 環境 (預設使用 kind，可使用參數 --k3d 啟動 k3d)
    stop [env_name]                     停止 k8s 環境 (預設停止 current.env 的當前使用中的 k8s 環境)
    restart                             重啟 k8s 環境 (預設停止 current.env 的當前使用中的 k8s 環境)
    status                              顯示 k8s 環境狀態
    remove, rm                          移除 k8s 環境
    current, cur                        顯示當前使用中的 k8s 環境名稱
    use [env_name]                      切換當前使用中的 k8s 環境名稱
    k9s [-p port]                       進入 k9s dashboard, 可使用 -p 參數，設定 k9s port-forward 的 port
    expose                              將 service/pod port forward 到本地指定的 port
    exec                                進入有部署相關工具的環境，並且掛載當前環境的 namespace 資料夾
    reset                               重置 kde 環境，清除全部 environments 和 projects 資料夾
    project, proj                       project 管理 (可以使用 kde project -h 查看詳細說明)
  ```

- 執行 `kde start` 啟動 / 新增 K8S

## 檔案結構說明

```
|_ dockerfiles/       (dockerfile)
|_ scripts/           (程式腳本)
|_ kde.sh             (主程式)
|_ install.sh         (安裝腳本)
|_ upgrade.sh         (升級腳本)
```

## 檔案結構說明 - 使用環境

```
|_ enviroments/           (環境變量存放位置)
  |_ kubeconfig/          (kubeconfig 存放位置)
  |_ pki/                 (k8s ca 存放位置)
  |_ namespace/           (k8s namespace，也是 volumes 存放位置)
    |_ *[namespace | project name]    (k8s namespace ，也是 project name)
      |_ project.env                      (project 的環境變數)
      |_ pre-deploy.sh                    (在部署過程中，會使用 project.env 設定的 DEVELOP_IMAGE 來執行的腳本)
      |_ deploy.sh                        (在部署過程中，會使用 project.env 設定的 DEPLOY_IMAGE 來執行的腳本)
      |_ *[pv name]/                      (volume 掛載資料夾，建立與資料夾相同名稱的 pv 即可連結)
|_ current.env            (當前環境相關資訊)
```

## TODO

#### Core Features

- [x] ls (列出 k8s 環境)
- [x] start (啟動 k8s 環境)
  - [x] kind (使用 kind 啟動 K8S)
  - [ ] k3d (使用 k3d 啟動 K8S)
- [x] stop (停止 k8s 環境)
- [x] restart (重啟 k8s 環境)
- [x] status (顯示 k8s 環境狀態)
- [x] remove (移除 k8s 環境)
- [x] current (顯示當前環境名稱)
- [x] k9s (啟動 k9s Dashboard)
- [x] expose (將 Pod/Service 暴露到外網)
- [x] exec (進入有部署相關工具的環境，並且掛載當前環境的 namespace 資料夾)
- [ ] reset (重置環境，刪除所有資料)
- [ ] project (相當於 namespace)
  - [x] ls (列出 namespace 資料夾底下的資料夾)
  - [x] create (將專案資料夾建立到 namespace 資料夾底下，並且建立 namespace)
  - [x] fetch (透過 git url 抓取專案)
  - [ ] link (建立專案資料夾的 softlink 到 namespace 資料夾底下)
  - [x] deploy (部署專案)
  - [x] undeploy (解除部署專案)
  - [x] redeploy (重新部署專案)
  - [x] remove (刪除專案)
  - [x] exec (進入專案的 Container 環境)
    - [x] develop (進入專案的開發 Container 環境)
    - [x] deploy (進入專案的部署 Container 環境)

#### Extra Features

- [ ] mcp server
- [ ] kube-metrics-server
- [ ] Grafana/Loki/Prometheus
- [ ] cert-manager
- [ ] ngrok / Cloudflare Tunnel

## 相關套件清單

- [k3d](https://k3d.io/stable/)
- [kind](https://kind.sigs.k8s.io/)
- [k9s](https://k9scli.io/)
- [rancher/local-path-provisioner](https://github.com/rancher/local-path-provisioner)
