# Terraform Configuration

This directory contains the Infrastructure-as-Code (IaC) for deploying the DevOps Simple Project to Kubernetes.

## Structure

```
devop-simple-project/
├── main.tf                      # Root module - calls terraform/ module
├── terraform/                   # Kubernetes deployment module
│   ├── provider.tf              # Kubernetes provider configuration
│   ├── variables.tf             # Input variables
│   ├── locals.tf                # Local values (namespace)
│   ├── deployments.tf           # Backend, Frontend, Prometheus, Grafana deployments
│   ├── services.tf              # Services and Ingress
│   ├── hpa.tf                   # Horizontal Pod Autoscaler
│   ├── configmaps.tf            # ConfigMaps for Prometheus and Grafana
│   ├── rbac.tf                  # Service Accounts, Roles, RoleBindings
│   ├── outputs.tf               # Output values
│   └── README.md                # Module documentation
├── k8s/                         # Configuration files
│   ├── prometheus.yml           # Prometheus configuration
│   ├── prometheus.rules         # Prometheus alerting rules
│   ├── grafana-datasources.yml  # Grafana datasource config
│   └── grafana-dashboards.yml   # Grafana dashboard config
└── .terraform/                  # Terraform state and plugins (generated)
```

## Quick Start

### Prerequisites
- Terraform >= 1.0
- Kubernetes cluster (Minikube, EKS, AKS, etc.)
- kubectl configured to access your cluster

### Deploy

```bash
cd devop-simple-project

# Initialize Terraform (download providers)
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply
```

### Customize

Edit `main.tf` module variables to customize:

```hcl
module "devop_deployment" {
  source = "./terraform"

  # Change these values as needed
  backend_image  = "your-backend-image:tag"
  frontend_image = "your-frontend-image:tag"
  
  enable_hpa         = true
  hpa_min_replicas   = 2
  hpa_max_replicas   = 10
  hpa_cpu_threshold  = 70
  
  grafana_admin_password = "your-password"
}
```

Or use `terraform apply -var` or `.tfvars` files:

```bash
terraform apply -var="backend_replicas=3" -var="enable_hpa=false"
```

### Destroy

```bash
terraform destroy
```

## Module Outputs

After applying, Terraform outputs useful service endpoints:

```bash
terraform output
```

## Key Features

- ✅ Full Kubernetes resource management (Deployments, Services, Ingress, HPA, RBAC)
- ✅ Modular structure for easy customization
- ✅ Prometheus + Grafana monitoring stack
- ✅ Horizontal Pod Autoscaler for backend
- ✅ Configurable variables for all deployments
- ✅ Service endpoints and ingress hostname output

## Module Variables

See `terraform/variables.tf` for all available input variables:

- `kubeconfig_path`: Path to kubeconfig (default: "")
- `kubeconfig_context`: Kubernetes context (default: "minikube")
- `namespace`: Kubernetes namespace (default: "default")
- `backend_image`: Backend container image (default: "devop-simple-project-backend:latest")
- `frontend_image`: Frontend container image (default: "devop-simple-project-frontend:latest")
- `enable_hpa`: Enable HPA for backend (default: true)
- `hpa_min_replicas`: HPA min replicas (default: 2)
- `hpa_max_replicas`: HPA max replicas (default: 10)
- `hpa_cpu_threshold`: CPU threshold % (default: 70)
- `hpa_memory_threshold`: Memory threshold % (default: 80)

## Troubleshooting

### Provider errors
If you get provider errors, ensure your kubeconfig is configured:
```bash
kubectl cluster-info
kubectl config get-contexts
```

### ConfigMap file not found
Ensure configuration files exist in `k8s/` directory:
```bash
ls -la k8s/prometheus.yml k8s/prometheus.rules k8s/grafana-*.yml
```

### State management
Terraform stores state in `.terraform.tfstate` (local state). For production, use remote state (S3, Azure Blob, Terraform Cloud).

