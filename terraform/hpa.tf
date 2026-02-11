# HorizontalPodAutoscaler for Backend
resource "kubernetes_horizontal_pod_autoscaler_v2" "backend" {
  count = var.enable_hpa ? 1 : 0

  metadata {
    name      = "backend-hpa"
    namespace = var.namespace
    labels = {
      app = "backend"
    }
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.backend.metadata[0].name
    }

    min_replicas = var.hpa_min_replicas
    max_replicas = var.hpa_max_replicas

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = var.hpa_cpu_threshold
        }
      }
    }

    metric {
      type = "Resource"

      resource {
        name = "memory"

        target {
          type                = "Utilization"
          average_utilization = var.hpa_memory_threshold
        }
      }
    }

    behavior {
      scale_up {
        stabilization_window_seconds = 0

        policy {
          type          = "Percent"
          value         = 100
          period_seconds = 15
        }

        policy {
          type          = "Pods"
          value         = 2
          period_seconds = 15
        }

        select_policy = "Max"
      }

      scale_down {
        stabilization_window_seconds = 300

        policy {
          type          = "Percent"
          value         = 50
          period_seconds = 15
        }

        select_policy = "Max"
      }
    }
  }

  depends_on = [kubernetes_deployment_v1.backend]
}
