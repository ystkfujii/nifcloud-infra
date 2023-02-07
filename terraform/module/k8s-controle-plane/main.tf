#####
# Local
#
locals {
  delimiter = "7"
}

#####
# Data
#
data "nifcloud_image" "ubuntu" {
  image_name = var.ubuntu_image_name
}

#####
# Security Group 
#
resource "nifcloud_security_group" "controle_plane" {
  group_name        = "controleplane"
  description       = "k8s controle plane"
  availability_zone = var.availability_zone
}

#####
# Instance
#
resource "nifcloud_instance" "controle_plane" {
  count = var.number_of_controle_plane

  instance_id       = "cp${local.delimiter}node${count.index}"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.instance_key_name
  security_group    = nifcloud_security_group.controle_plane.group_name
  instance_type     = var.controle_plane_type
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }

  network_interface {
    network_id = var.private_network_info.id
  }
}

#####
# LB
#
resource "nifcloud_load_balancer" "l4lb4cp" {
  load_balancer_name = "l4lb4cp"
  accounting_type = var.accounting_type
  balancing_type = 1 // Round-Robin
  instance_port = 443
  load_balancer_port = 443
  instances = nifcloud_instance.controle_plane[*].instance_id
}

#####
# Security Group Rule
#
resource "nifcloud_security_group_rule" "kubectl_from_lb" {
  security_group_names = [
    nifcloud_security_group.controle_plane.group_name,
  ]
  type                 = "IN"
  from_port            = 6443
  to_port              = 6443
  protocol             = "TCP"
  cidr_ip              = nifcloud_load_balancer.l4lb4cp.dns_name
}

resource "nifcloud_security_group_rule" "ssh_from_bastion" {
  security_group_names = [
    nifcloud_security_group.controle_plane.group_name,
  ]
  type                 = "IN"
  from_port            = 22
  to_port              = 22
  protocol             = "TCP"
  source_security_group_name = var.bastion_security_group
}