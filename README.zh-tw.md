# Kubernetes Development Environment (KDE)

KDE 是一個本地 Kubernetes 開發環境管理工具，協助開發者使用 Docker 建立和管理 K8S/K3S 環境。它支援使用 Docker 來建立 K8S/K3S 環境，並提供便捷的開發體驗。

## 主要功能

- 快速建立本地 Kubernetes 環境（支援 Kind 和 K3D）
- 整合 K9S 管理介面，提供直觀的叢集管理體驗
- 支援多環境管理，可輕鬆切換不同的開發環境
- 專案管理功能，支援 Git 倉庫整合
- 自動化部署流程，簡化開發工作流程
- 支援容器化開發環境，提供一致的開發體驗

## 系統需求

- Docker
- 系統管理員權限（用於安裝和部分操作）

## 安裝方式

1. 下載專案後，執行安裝腳本：

```bash
sudo ./install.sh
```

2. 移除 KDE（選擇以下任一方式）：
   - 自動移除：
     ```bash
     sudo ./uninstall.sh
     ```
   - 手動移除：
     ```bash
     sudo rm /usr/local/bin/kde
     sudo rm -rf /usr/local/lib/kde
     ```

## 使用指南

### 基本命令

```bash
kde <command>
```

### 常用命令說明

- `list, ls` - 列出所有 Kubernetes 環境
- `start <env_name> [--k3d]` - 建立/啟動 Kubernetes 環境（預設使用 Kind，可選用 K3D）
- `create <env_name> [--k3d]` - 建立新的 Kubernetes 環境
- `stop [env_name]` - 停止指定的 Kubernetes 環境
- `restart` - 重啟當前環境
- `status` - 顯示環境狀態
- `remove, rm` - 移除環境
- `current, cur` - 顯示當前使用的環境
- `use [env_name]` - 切換環境
- `k9s [-p port]` - 啟動 K9S 管理介面
- `expose` - 設定服務/Pod 的端口轉發
- `exec` - 進入 Kubernetes 節點容器環境
- `reset` - 重置所有環境
- `project, proj` - 專案管理
- `projects, projs` - 專案集合管理

### 專案與命名空間概念

在 KDE 中，我們將 Kubernetes 的命名空間（Namespace）視為一個專案（Project）。這種設計有以下優點：

1. **資源隔離**：每個專案都有獨立的命名空間，確保不同專案之間的資源互不干擾
2. **權限管理**：可以為每個命名空間設定獨立的存取權限
3. **資源配額**：可以為每個命名空間設定資源使用限制
4. **開發環境隔離**：不同開發者可以在各自的命名空間中進行開發，不會互相影響

當您使用 `kde project` 命令時，實際上是在管理 Kubernetes 的命名空間。例如：

- `kde project create my-project` 會建立一個名為 `my-project` 的命名空間
- `kde project deploy my-project` 會將應用程式部署到 `my-project` 命名空間中
- `kde project exec my-project` 提供兩種模式（預設為 develop 模式）：
  - `kde project exec my-project develop` 或 `kde project exec my-project` - 進入 `project.env` 中設定的 develop image container 環境，用於開發和測試
  - `kde project exec my-project deploy` - 進入 `project.env` 中設定的 deploy image container 環境，用於部署和運行

### 專案集合管理

專案集合（Projects）是一個更高層級的管理單位，用於管理多個相關的專案。使用 `kde projects` 命令可以：

- `kde projects list` - 列出所有專案集合
- `kde projects exec my-collection` - 進入專案集合的開發環境，這個命令會：
  - 自動建立並啟動專案集合中所有專案的開發環境
  - 提供一個統一的開發介面，讓您可以同時管理多個相關專案
  - 支援跨專案的資源共享和協作

### 專案管理

每個 Kubernetes namespace 對應一個專案，專案資料夾結構如下：

```
environments/
  ├── [env_name]/              # 環境名稱
  │   ├── kubeconfig/         # Kubernetes 配置文件
  │   ├── pki/                # 證書文件
  │   ├── .env               # 環境變數
  │   ├── kind-config.yaml   # Kind 配置
  │   ├── k3d-config.yaml    # K3D 配置
  │   └── namespaces/        # 專案集合
  │       └── [project_name]/ # 專案資料夾
  │           ├── project.env # 專案配置
  │           ├── pre-deploy.sh # 部署前腳本
  │           ├── deploy.sh   # 部署腳本
  │           └── [pv_name]/  # 持久化存儲
  └── current.env            # 當前環境配置
```

## 開發中的功能

### 核心功能

- [x] 環境管理（建立、啟動、停止、重啟）
- [x] 專案管理（建立、部署、移除）
- [x] K9S 整合
- [x] 端口轉發
- [ ] 專案集合管理
- [ ] 更多開發工具整合

### 額外功能

- [ ] 監控系統整合（Grafana/Loki/Prometheus）
- [ ] 證書管理（cert-manager）
- [ ] 外部訪問（ngrok/Cloudflare Tunnel）

## 相關套件

- [k3d](https://k3d.io/stable/) - 輕量級 Kubernetes 發行版
- [kind](https://kind.sigs.k8s.io/) - 本地 Kubernetes 叢集
- [k9s](https://k9scli.io/) - 終端機 UI
- [rancher/local-path-provisioner](https://github.com/rancher/local-path-provisioner) - 本地存儲供應器
