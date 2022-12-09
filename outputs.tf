output "this" {
  value = kubernetes_service_account_v1.this
}

output "cluster_roles" {
  value = kubernetes_cluster_role.this
}

output "token" {
  value = kubernetes_secret_v1.this.data.token
}

output "ca_crt" {
  value = kubernetes_secret_v1.this.data["ca.crt"]
}