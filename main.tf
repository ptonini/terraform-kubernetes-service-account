resource "kubernetes_service_account_v1" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    generate_name = var.name
    namespace     = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = var.name
    }
  }
  type = "kubernetes.io/service-account-token"
}

module "cluster_role" {
  source  = "ptonini/cluster-role/kubernetes"
  version = "~> 1.1.0"
  count   = length(var.cluster_role_rules) > 0 ? 1 : 0
  name    = kubernetes_service_account_v1.this.metadata[0].name
  rules   = var.cluster_role_rules
  subject = {
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = kubernetes_service_account_v1.this.metadata[0].namespace
  }
}