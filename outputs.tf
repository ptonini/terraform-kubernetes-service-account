output "this" {
  value = kubernetes_service_account_v1.this
}

output "secret" {
  value = kubernetes_secret_v1.this.data
}