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

variable "number_of_controle_plane" {
  type = number
  default = 1
}

variable "controle_plane_type" {
  type = string
  default = "e-large16"
}


variable "ubuntu_image_name" {
  type = string
  default = "Ubuntu Server 22.04 LTS"
}

variable "accounting_type" {
  type = string
  default = "1"  // Monthly
}

