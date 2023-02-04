variable "availability_zone" {
  type = string
}

variable "controle_plane_gip" {  
  type = list(string)
}

variable "worker_gip" {  
  type = list(string)
}

variable "lb_gip" {  
  type = list(string)
}

variable "egress_gip" {  
  type = list(string)
}

variable "bastion_gip" {  
  type = list(string)
}

variable "private_network" {
  type = object({
    id = string
    name = string
  })
}

variable "router" {
  type = object({
    ip_address  = string
    pool_ip_start = string
    pool_ip_stop = string
  })
}

variable "cluster_resource_only" {
  type = bool
  default = false
}