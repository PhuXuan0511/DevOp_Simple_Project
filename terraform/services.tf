# Backend Service
resource "kubernetes_service_v1" "backend" {
  metadata {
    name      = "backend"
    namespace = var.namespace
    labels = {
      app = "backend"
    }
  }

  spec {
    selector = {
      app = "backend"
    }

    type = "ClusterIP"

    port {
      port        = var.backend_port
      target_port = var.backend_port
      protocol    = "TCP"
    }
  }

  depends_on = [kubernetes_namespace_v1.default]
}

# Frontend Service
resource "kubernetes_service_v1" "frontend" {
  metadata {
    name      = "frontend"
    namespace = var.namespace
    labels = {
      app = "frontend"
    }
  }

  spec {
    selector = {
      app = "frontend"
    }

    type = "ClusterIP"

    port {
      port        = var.frontend_port
      target_port = var.frontend_port
      protocol    = "TCP"
    }
  }

  depends_on = [kubernetes_namespace_v1.default]
}

# Prometheus Service
resource "kubernetes_service_v1" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = var.namespace
    labels = {
      app = "prometheus"
    }
  }

  spec {
    selector = {
      app = "prometheus"
    }

    type = "ClusterIP"

    port {
      port        = 9090
      target_port = 9090
      protocol    = "TCP"
    }
  }

  depends_on = [kubernetes_namespace_v1.default]
}

# Grafana Service
resource "kubernetes_service_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = var.namespace
    labels = {
      app = "grafana"
    }
  }

  spec {
    selector = {
      app = "grafana"
    }

    type = "ClusterIP"

    port {
      port        = 3000
      target_port = 3000
      protocol    = "TCP"
    }
  }

  depends_on = [kubernetes_namespace_v1.default]
}

# Ingress
resource "kubernetes_ingress_v1" "app" {
  metadata {
    name      = "app-ingress"
    namespace = var.namespace
    labels = {
      app = "app"
    }
  }

  spec {
    rule {
      host = var.ingress_hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.frontend.metadata[0].name
              port {
                number = var.frontend_port
              }
            }
          }
        }

        path {
          path      = "/api"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.backend.metadata[0].name
              port {
                number = var.backend_port
              }
            }
          }
        }

        path {
          path      = "/prometheus"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.prometheus.metadata[0].name
              port {
                number = 9090
              }
            }
          }
        }

        path {
          path      = "/grafana"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.grafana.metadata[0].name
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service_v1.frontend,
    kubernetes_service_v1.backend,
    kubernetes_service_v1.prometheus,
    kubernetes_service_v1.grafana
  ]
}
