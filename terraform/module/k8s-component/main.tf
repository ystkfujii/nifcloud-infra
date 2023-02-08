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

data "template_file" "script" {
  template = file("${path.module}/scripts/userdata.sh")

  vars = {
    controle_plane_network = "test"
  }
}

#####
# Security Group 
#
resource "nifcloud_security_group" "this" {
  group_name        = "${var.unique_name}instnc"
  description       = "${var.unique_name}instnc"
  availability_zone = var.availability_zone
}

#####
# Instance
#
resource "nifcloud_instance" "this" {
  count = var.instance_count

  instance_id       = "${var.unique_name}${local.delimiter}node${count.index}"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.instance_key_name
  security_group    = nifcloud_security_group.this.group_name
  instance_type     = var.instance_type
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }

  network_interface {
    network_id = var.bridge_network_id
  }
  
  user_data = data.template_file.script.rendered
}

#####
# LB
#
resource "nifcloud_load_balancer" "l4lb4cp" {
  load_balancer_name = "${var.unique_name}l4lb4"
  accounting_type = var.accounting_type
  balancing_type = 1 // Round-Robin
  instance_port = 443
  load_balancer_port = 443
  instances = nifcloud_instance.this[*].instance_id
}

#####
# Security Group Rule
#
resource "nifcloud_security_group_rule" "kubectl_from_lb" {
  security_group_names = [
    nifcloud_security_group.this.group_name,
  ]
  type                 = "IN"
  from_port            = var.instance_listen_port.from
  to_port              = var.instance_listen_port.to
  protocol             = "TCP"
  cidr_ip              = nifcloud_load_balancer.l4lb4cp.dns_name
}

resource "nifcloud_security_group_rule" "kubelet_from_bridge_network" {
  security_group_names = [
    nifcloud_security_group.this.group_name,
  ]
  type                 = "IN"
  from_port            = 10250
  to_port              = 10250
  protocol             = "TCP"
  cidr_ip              = var.bridge_network_cidr
}


resource "nifcloud_security_group_rule" "ssh_from_cluster_network" {
  security_group_names = [
    nifcloud_security_group.this.group_name,
  ]
  type                 = "IN"
  from_port            = 22
  to_port              = 22
  protocol             = "TCP"
  cidr_ip              = var.bridge_network_cidr
}