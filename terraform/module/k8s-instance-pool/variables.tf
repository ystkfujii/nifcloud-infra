variable "availability_zone" {
  type = string
}

variable "pool_role" {
  type = object({
    full_name  = string
    short_name = string
  })
}

variable "instance_key_name" {
  type = string
}

variable "instnce_global_ip" {
  type = list(string)  
}

variable "private_network_info" {
  type = object({
    id   = string
    name = string
  })
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

