data "kubernetes_secret" "this" {
  provider = kubernetes
  metadata {
    name = kubernetes_service_account.this.default_secret_name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}