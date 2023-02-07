variable "availability_zone" {
  type = string
}

variable "instance_key_name" {
  type = string
}

variable "private_network_info" {
  type = object({
    id   = string
    name = string
  })
}

variable "bastion_security_group" {
  type = string
}

variable "egress_global_ip" {
  type = string
}

variable "controle_plane_network" {
  type = string  
}

variable "bridge_router_ip" {
  type = string
}

variable "number_of_worker" {
  type = number
  default = 1
}

variable "worker_type" {
  type = string
  default = "e-large16"
}

variable "egress_type" {
  type = string
  default = "c-medium"
}

variable "ubuntu_image_name" {
  type = string
  default = "Ubuntu Server 22.04 LTS"
}

variable "accounting_type" {
  type = string
  default = "1"  // Monthly
}

