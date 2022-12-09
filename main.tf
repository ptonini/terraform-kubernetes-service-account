locals {
  cluster_roles = toset(compact(concat(
    [ for r in kubernetes_cluster_role.this : r.metadata[0].name ],
    var.cluster_role_bindings
  )))
}

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

resource "kubernetes_cluster_role" "this" {
  count    = length(var.cluster_role_rules) > 0 ? 1 : 0
  metadata {
    name = kubernetes_service_account_v1.this.metadata[0].name
  }
  dynamic "rule" {
    for_each = { for i, v in var.cluster_role_rules : i => v }
    content {
      api_groups = rule.value["api_groups"]
      resources  = rule.value["resources"]
      verbs      = rule.value["verbs"]
    }
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  provider = kubernetes
  for_each = var.create_bindings ? local.cluster_roles : []
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