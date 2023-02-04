variable "availability_zone" {
  type = string
}

variable "private_network_cidr" {
  type = string
}

variable "elastic_ip" {
  type =  object({
    controle_plane = number
    worker = number
    lb = number
    bastion = number
    egress = number
  })
}