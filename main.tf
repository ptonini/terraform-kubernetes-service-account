resource "kubernetes_service_account" "this" {
  provider = kubernetes
  metadata {
    name = var.name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "this" {
  provider = kubernetes
  count = length(var.cluster_role_rules) > 0 ? 1 : 0
  metadata {
    name = kubernetes_service_account.this.metadata[0].name
  }
  dynamic "rule" {
    for_each = {for i, v in var.cluster_role_rules : i => v }
    content {
      api_groups = rule.value["api_groups"]
      resources = rule.value["resources"]
      verbs = rule.value["verbs"]
    }
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  provider = kubernetes
  for_each = toset(concat(length(var.cluster_role_rules) > 0 ? [kubernetes_cluster_role.this[0].metadata[0].name] : [], var.cluster_role_bindings))
  metadata {
    name = kubernetes_service_account.this.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = each.value
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}