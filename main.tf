resource "kubernetes_service_account_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
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
  source = "ptonini/cluster-role/kubernetes"
  version = "~> 1.0.0"
  count  = length(var.cluster_role_rules) > 0 ? 1 : 0
  name   = kubernetes_service_account_v1.this.metadata[0].name
  rules  = var.cluster_role_rules
}

resource "kubernetes_cluster_role_binding" "this" {
  provider = kubernetes
  for_each = var.create_bindings ? toset(compact(concat([module.cluster_role[0].this.metadata[0].name], var.cluster_role_bindings))) : []
  metadata {
    name = kubernetes_service_account_v1.this.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata[0].name
    namespace = kubernetes_service_account_v1.this.metadata[0].namespace
  }
}