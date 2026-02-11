variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = ""
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = "minikube"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy to"
  type        = string
  default     = "default"
}

variable "backend_image" {
  description = "Backend container image"
  type        = string
  default     = "devop-simple-project-backend:latest"
}

variable "backend_replicas" {
  description = "Number of backend replicas"
  type        = number
  default     = 2
}

variable "backend_port" {
  description = "Backend service port"
  type        = number
  default     = 8000
}

variable "frontend_image" {
  description = "Frontend container image"
  type        = string
  default     = "devop-simple-project-frontend:latest"
}

variable "frontend_port" {
  description = "Frontend service port"
  type        = number
  default     = 80
}

variable "prometheus_image" {
  description = "Prometheus container image"
  type        = string
  default     = "prom/prometheus:latest"
}

variable "grafana_image" {
  description = "Grafana container image"
  type        = string
  default     = "grafana/grafana:latest"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "enable_hpa" {
  description = "Enable Horizontal Pod Autoscaler for backend"
  type        = bool
  default     = true
}

variable "hpa_min_replicas" {
  description = "HPA minimum replicas for backend"
  type        = number
  default     = 2
}

variable "hpa_max_replicas" {
  description = "HPA maximum replicas for backend"
  type        = number
  default     = 10
}

variable "hpa_cpu_threshold" {
  description = "HPA CPU utilization threshold percentage"
  type        = number
  default     = 70
}

variable "hpa_memory_threshold" {
  description = "HPA memory utilization threshold percentage"
  type        = number
  default     = 80
}

variable "ingress_hostname" {
  description = "Ingress hostname"
  type        = string
  default     = "devop-simple.local"
}
