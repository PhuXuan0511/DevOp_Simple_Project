# DevOp Simple Project

This repository is a small example microservice application demonstrating a full DevOps workflow: local development with Docker Compose, container builds, CI/CD with Jenkins, deployment to Kubernetes with Terraform and Ansible, and monitoring with Prometheus and Grafana.

Contents
--------
- `backend/` — FastAPI backend service (metrics, health checks)
- `frontend/` — Static frontend served by Nginx
- `k8s/` — Kubernetes manifests and monitoring config (Prometheus/Grafana)
- `terraform/` — Terraform module to provision Kubernetes resources
- `ansible/` — Ansible playbook to build/push images and deploy (CI-friendly)
- `helm/` — Helm chart (app packaging)
- `Jenkinsfile` — Example Jenkins pipeline for CI/CD
- `docker-compose.yml` — Local development setup

Goals
-----
- Show a simple but realistic microservice layout (backend + frontend).
- Demonstrate container builds, registry pushes, and automated deployments.
- Provide both declarative (Terraform/Helm) and imperative (Ansible) deployment paths.
- Include monitoring (Prometheus + Grafana) and basic observability.

Prerequisites
-------------
- Docker & Docker Compose (for local development)
- kubectl configured for your Kubernetes cluster
- Terraform >= 1.0 (if using Terraform path)
- Ansible 2.10+ with collections (if using Ansible playbook)
- Helm (if using the Helm chart)
- Jenkins (optional, for CI)

Quick Start — Local (Docker Compose)
-----------------------------------
1. Build and run:

```bash
docker-compose up --build -d
```

2. Check services:

```bash
docker-compose ps
```

3. Open the frontend: http://localhost
4. Backend health: http://localhost:8000/health

CI / Build / Deploy (Jenkins)
------------------------------
The included `Jenkinsfile` demonstrates a pipeline that:
- Builds backend and frontend Docker images
- Tags images with `${BUILD_TAG}` and `latest`
- Pushes images to a Docker registry (configured via Jenkins credentials)
- Calls the Ansible playbook to deploy to Kubernetes

To run on Jenkins:
1. Create Jenkins credentials for the Docker registry (example id: `docker-creds`).
2. Ensure the Jenkins agent has Docker, Ansible, kubectl, and Helm available.
3. Create a pipeline job pointing at this repo and run it.

Deployment Options
------------------
You have multiple deployment paths depending on your needs.

1) Terraform (declarative infra):

 - Go to the `terraform/` folder, edit `variables.tf` if needed.
 - Initialize and apply:

```bash
cd terraform
terraform init
terraform apply
```

This will create Kubernetes resources (Deployments, Services, ConfigMaps, RBAC, HPA).

2) Ansible (CI-driven deployments):

- Install required Ansible collections:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

- Run playbook (example):

```bash
export REGISTRY_USER=you
export REGISTRY_PASSWORD=pass
export BUILD_TAG=ci-$(git rev-parse --short HEAD)
export KUBECONFIG=~/.kube/config
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

Ansible will build and push images, then apply manifests or deploy the Helm chart depending on configuration.

3) Helm (packaged chart):

- A Helm chart is available under `helm/devop-simple-project`.
- Deploy via Helm:

```bash
helm upgrade --install devop-simple-project helm/devop-simple-project \
	--namespace default --create-namespace \
	--set backend.image=docker.io/youruser/devop-simple-project-backend:TAG \
	--set frontend.image=docker.io/youruser/devop-simple-project-frontend:TAG
```

Monitoring
----------
- Prometheus and Grafana are included as Kubernetes deployments and configured via the `k8s/` manifests or Terraform `configmaps.tf`.
- Prometheus scrapes the backend using annotations.
- Access Prometheus: port-forward the service or expose via Ingress.

Project Structure (high level)
------------------------------
- `backend/`
	- `backend.py` — FastAPI app with Prometheus middleware
	- `requirements.txt` — Python dependencies
	- `Dockerfile` — builds backend image

- `frontend/`
	- `frontend.html` — static files
	- `nginx.conf` — reverse proxy and static server config
	- `Dockerfile` — builds frontend image

- `terraform/` — Kubernetes resource definitions via Terraform
- `ansible/` — Ansible playbook, inventory, and requirements
- `helm/` — Helm chart for application packaging
- `k8s/` — raw Kubernetes manifests and monitoring config
- `Jenkinsfile` — CI pipeline
- `docker-compose.yml` — local dev orchestration

Security Notes
--------------
- Use Jenkins credentials or Ansible Vault to protect registry credentials and sensitive values.
- For production, enable TLS (Ingress), NetworkPolicies, Secrets management.

Maintenance & Troubleshooting
-----------------------------
- Check pod status: `kubectl get pods -n <namespace>`
- Logs: `kubectl logs deploy/<name> -n <namespace>`
- Describe resources: `kubectl describe pod <pod>`
- Prometheus targets: visit Prometheus UI and verify scrapes


License & Attribution
---------------------
This project is a sample/demo repository. Review code and configuration before using in production.


