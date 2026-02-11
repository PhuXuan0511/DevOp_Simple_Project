# Namespace (optional, using default)
resource "kubernetes_namespace_v1" "default" {
  metadata {
    name = var.namespace
  }

  lifecycle {
    ignore_changes = [metadata[0].labels]
  }
}
