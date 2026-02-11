# Prometheus ConfigMap
resource "kubernetes_config_map_v1" "prometheus_config" {
  metadata {
    name      = "prometheus-config"
    namespace = var.namespace
    labels = {
      app = "prometheus"
    }
  }

  data = {
    "prometheus.yml" = file("${path.module}/../k8s/prometheus.yml")
  }
}

# Prometheus Rules ConfigMap
resource "kubernetes_config_map_v1" "prometheus_rules" {
  metadata {
    name      = "prometheus-rules"
    namespace = var.namespace
    labels = {
      app = "prometheus"
    }
  }

  data = {
    "prometheus.rules" = file("${path.module}/../k8s/prometheus.rules")
  }
}

# Grafana Provisioning ConfigMap
resource "kubernetes_config_map_v1" "grafana_provisioning" {
  metadata {
    name      = "grafana-provisioning"
    namespace = var.namespace
    labels = {
      app = "grafana"
    }
  }

  data = {
    "datasources.yml" = file("${path.module}/../k8s/grafana-datasources.yml")
    "dashboards.yml"  = file("${path.module}/../k8s/grafana-dashboards.yml")
  }
}
