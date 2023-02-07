variable "unique_name" {
  type = string  
}

variable "availability_zone" {
  type = string
}

variable "bridge_network" {
  type = object({
    cidr = string
    router_ip_address = string
  })
}

variable "private_network" {
  type = object({
    cidr = string
    router_ip_address = string
  })
}

variable "controle_plane_network" {
  type = string
}

variable "next_hop" {
  type = string
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