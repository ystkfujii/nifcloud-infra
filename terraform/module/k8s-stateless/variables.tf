variable "env" {
  type = string
  validation {
    condition = length(var.env) == 3
    error_message = "Must be a 3 charactor long"
  }
}

variable "key_name" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "private_network_info" {
  type = object({
    id   = string
    name = string
  })
}

variable "eip_k8s_cp" {
  type = list(string)
}

variable "eip_k8s_node" {
  type = list(string)
}

variable "eip_ops_server" {
  type = list(string)
}

variable "eip_proxy_server" {
  type = list(string)
}

variable "accounting_type" {
  type = string
  default = "1"  // Monthly
}