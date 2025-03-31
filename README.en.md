# Kubernetes Development Environment (KDE)

KDE is a local Kubernetes development environment management tool that helps developers create and manage K8S/K3S environments using Docker.

## Key Features

- Quick setup of local Kubernetes environments (supports Kind and K3D)
- Integrated K9S management interface for intuitive cluster management
- Multi-environment support with easy switching between different development environments
- Project management capabilities with Git repository integration
- Automated deployment process to simplify development workflow
- Containerized development environment for consistent development experience

## System Requirements

- Docker
- System administrator privileges (for installation and certain operations)

## Installation

1. After downloading the project, run the installation script:

```bash
sudo ./install.sh
```

2. To remove KDE (choose one of the following methods):
   - Automatic removal:
     ```bash
     sudo ./uninstall.sh
     ```
   - Manual removal:
     ```bash
     sudo rm /usr/local/bin/kde
     sudo rm -rf /usr/local/lib/kde
     ```

## Usage Guide

### Basic Commands

```bash
kde <command>
```

### Common Commands

- `list, ls` - List all Kubernetes environments
- `start <env_name> [--k3d]` - Create/start Kubernetes environment (defaults to Kind, K3D optional)
- `create <env_name> [--k3d]` - Create a new Kubernetes environment
- `stop [env_name]` - Stop the specified Kubernetes environment
- `restart` - Restart the current environment
- `status` - Display environment status
- `remove, rm` - Remove environment
- `current, cur` - Show current environment
- `use [env_name]` - Switch environment
- `k9s [-p port]` - Launch K9S management interface
- `expose` - Set up service/Pod port forwarding
- `exec` - Enter Kubernetes node container environment
- `reset` - Reset all environments
- `project, proj` - Project management
- `projects, projs` - Project collection management

### Project and Namespace Concept

In KDE, we treat Kubernetes Namespaces as Projects. This design offers several benefits:

1. **Resource Isolation**: Each project has its own namespace, ensuring resources between different projects don't interfere with each other
2. **Permission Management**: Independent access permissions can be set for each namespace
3. **Resource Quotas**: Resource usage limits can be set for each namespace
4. **Development Environment Isolation**: Different developers can work in their own namespaces without affecting each other

When you use the `kde project` command, you are actually managing Kubernetes namespaces. For example:

- `kde project create my-project` creates a namespace named `my-project`
- `kde project deploy my-project` deploys applications to the `my-project` namespace
- `kde project exec my-project` offers two modes (develop mode is default):
  - `kde project exec my-project develop` or `kde project exec my-project` - Enter the develop image container environment specified in `project.env`, used for development and testing
  - `kde project exec my-project deploy` - Enter the deploy image container environment specified in `project.env`, used for deployment and runtime

### Project Collection Management

Project Collections (Projects) are a higher-level management unit for managing multiple related projects. Using the `kde projects` command, you can:

- `kde projects list` - List all project collections
- `kde projects exec my-collection` - Enter the development environment of a project collection, which will:
  - Automatically create and start development environments for all projects in the collection
  - Provide a unified development interface for managing multiple related projects
  - Support resource sharing and collaboration across projects

### Project Management

Each Kubernetes namespace corresponds to a project. The project folder structure is as follows:

```
environments/
  ├── [env_name]/              # Environment name
  │   ├── kubeconfig/         # Kubernetes configuration files
  │   ├── pki/                # Certificate files
  │   ├── .env               # Environment variables
  │   ├── kind-config.yaml   # Kind configuration
  │   ├── k3d-config.yaml    # K3D configuration
  │   └── namespaces/        # Project collections
  │       └── [project_name]/ # Project folder
  │           ├── project.env # Project configuration
  │           ├── pre-deploy.sh # Pre-deployment script
  │           ├── deploy.sh   # Deployment script
  │           └── [pv_name]/  # Persistent volumes
  └── current.env            # Current environment configuration
```

## Features in Development

### Core Features

- [x] Environment management (create, start, stop, restart)
- [x] Project management (create, deploy, remove)
- [x] K9S integration
- [x] Port forwarding
- [ ] Project collection management
- [ ] Additional development tool integration

### Additional Features

- [ ] Monitoring system integration (Grafana/Loki/Prometheus)
- [ ] Certificate management (cert-manager)
- [ ] External access (ngrok/Cloudflare Tunnel)

## Related Packages

- [k3d](https://k3d.io/stable/) - Lightweight Kubernetes distribution
- [kind](https://kind.sigs.k8s.io/) - Local Kubernetes cluster
- [k9s](https://k9scli.io/) - Terminal UI
- [rancher/local-path-provisioner](https://github.com/rancher/local-path-provisioner) - Local storage provisioner
