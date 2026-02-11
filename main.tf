terraform {
  required_version = ">= 1.0.0"
}

module "devop_deployment" {
  source = "./terraform"

  # Kubeconfig
  kubeconfig_context = "minikube"

  # Images
  backend_image  = "devop-simple-project-backend:latest"
  frontend_image = "devop-simple-project-frontend:latest"

  # Scaling
  enable_hpa         = true
  hpa_min_replicas   = 2
  hpa_max_replicas   = 10
  hpa_cpu_threshold  = 70
  hpa_memory_threshold = 80

  # Ingress
  ingress_hostname = "devop-simple.local"

  # Grafana
  grafana_admin_password = "admin"
}

output "kubernetes_services" {
  description = "Kubernetes services deployed"
  value = {
    backend    = module.devop_deployment.backend_service_endpoint
    frontend   = module.devop_deployment.frontend_service_endpoint
    prometheus = module.devop_deployment.prometheus_service_endpoint
    grafana    = module.devop_deployment.grafana_service_endpoint
  }
}

output "ingress" {
  description = "Ingress configuration"
  value       = "Access via: http://${module.devop_deployment.ingress_host}"
}

output "hpa_config" {
  description = "HPA configuration"
  value = {
    enabled      = module.devop_deployment.hpa_enabled
    min_replicas = module.devop_deployment.hpa_min_replicas
    max_replicas = module.devop_deployment.hpa_max_replicas
  }
}
