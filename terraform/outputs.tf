output "backend_service_name" {
  description = "Backend service name"
  value       = kubernetes_service_v1.backend.metadata[0].name
}

output "backend_service_endpoint" {
  description = "Backend service endpoint"
  value       = "${kubernetes_service_v1.backend.metadata[0].name}.${var.namespace}.svc.cluster.local:${var.backend_port}"
}

output "frontend_service_name" {
  description = "Frontend service name"
  value       = kubernetes_service_v1.frontend.metadata[0].name
}

output "frontend_service_endpoint" {
  description = "Frontend service endpoint"
  value       = "${kubernetes_service_v1.frontend.metadata[0].name}.${var.namespace}.svc.cluster.local:${var.frontend_port}"
}

output "prometheus_service_endpoint" {
  description = "Prometheus service endpoint"
  value       = "${kubernetes_service_v1.prometheus.metadata[0].name}.${var.namespace}.svc.cluster.local:9090"
}

output "grafana_service_endpoint" {
  description = "Grafana service endpoint"
  value       = "${kubernetes_service_v1.grafana.metadata[0].name}.${var.namespace}.svc.cluster.local:3000"
}

output "ingress_host" {
  description = "Ingress hostname"
  value       = var.ingress_hostname
}

output "backend_deployment_name" {
  description = "Backend deployment name"
  value       = kubernetes_deployment_v1.backend.metadata[0].name
}

output "hpa_enabled" {
  description = "HPA status"
  value       = var.enable_hpa
}

output "hpa_min_replicas" {
  description = "HPA minimum replicas"
  value       = var.hpa_min_replicas
}

output "hpa_max_replicas" {
  description = "HPA maximum replicas"
  value       = var.hpa_max_replicas
}
