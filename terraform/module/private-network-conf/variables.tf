variable "availability_zone" {
  type = string
}

variable "router_ip_address" {
  type = string
}

variable "private_network_info" {
  type = object({
    id   = string
    name = string
  })
}

variable "dhcp_config" {
  type = object({
    ipaddress_pool_start = string
    ipaddress_pool_stop   = string
  })
}

variable "router_type" {
  type = string
  default = "small"
}

variable "accounting_type" {
  type = string
  default = "1"  // Monthly
}