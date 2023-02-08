variable "availability_zone" {
  type = string
}
variable "unique_name" {
  type = string
}

variable "bridge_network_cidr" {
  type = string
}

variable "router_ip_address" {
  type = string
}

variable "dhcp_config" {
  type = object({
    ipaddress_pool_start = string
    ipaddress_pool_stop   = string
  })
}

variable "instance_key_name" {
  type = string
}

variable "bastion" {
  type = object({
    public_ip = string
    instance_type = string
  })
}

variable "egress" {
  type = object({
    public_ip = string
    instance_type = string
  })
}

variable "router_type" {
  type = string
  default = "small"
}

variable "ubuntu_image_name" {
  type = string
  default = "Ubuntu Server 22.04 LTS"
}

variable "accounting_type" {
  type = string
  default = "1"  // Monthly
}