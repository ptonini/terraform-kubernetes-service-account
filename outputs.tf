output "this" {
  value = kubernetes_service_account_v1.this
}

output "token" {
  value = kubernetes_secret_v1.this.data.token
}

output "ca_crt" {
  value = kubernetes_secret_v1.this.data["ca.crt"]
}