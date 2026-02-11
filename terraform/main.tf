# Terraform module for Kubernetes deployment
# This file can be run standalone from terraform/ folder OR called as module from root main.tf
# All resources defined in: deployments.tf, services.tf, hpa.tf, configmaps.tf, rbac.tf, outputs.tf

terraform {
  required_version = ">= 1.0.0"
}