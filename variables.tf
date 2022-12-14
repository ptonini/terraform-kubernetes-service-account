variable "name" {}

variable "namespace" {}

variable "create_token" {
  default = true
}

variable "cluster_role_rules" {
  type = list(object({
    api_groups = list(string)
    resources  = list(string)
    verbs      = list(string)
  }))
  default = []
}

variable "cluster_role_bindings" {
  type    = list(string)
  default = []
}

variable "create_bindings" {
  default = true
}