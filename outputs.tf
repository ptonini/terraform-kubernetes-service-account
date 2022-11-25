output "this" {
  value = kubernetes_service_account.this
}

output "token" {
  value = data.kubernetes_secret.this.data.token
}

output "ca_crt" {
  value = data.kubernetes_secret.this.data["ca.crt"]
}