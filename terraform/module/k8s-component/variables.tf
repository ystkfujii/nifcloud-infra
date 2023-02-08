variable "availability_zone" {
  type = string
}

variable "unique_name" {
  type = string
}

variable "instance_key_name" {
  type = string
}

variable "instance_count" {
  type = number  
}

variable "instance_listen_port" {
  type = object({
    from = number
    to = number
  })
}

variable "bridge_network_cidr" {
  type = string
}

variable "bridge_network_id" {
  type = string
}

variable "router_type" {
  type = string
  default = "small"
}

variable "instance_type" {
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

