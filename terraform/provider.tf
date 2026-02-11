terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Provider configuration
# When running from terraform/ folder: uses default kubeconfig
# When running from root via module: receives kubeconfig_path variable
provider "kubernetes" {
  config_path    = try(var.kubeconfig_path, "")
  config_context = try(var.kubeconfig_context, "minikube")
}
