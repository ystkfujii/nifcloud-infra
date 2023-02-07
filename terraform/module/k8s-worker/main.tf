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
  template = file("scripts/userdata.sh")

  vars = {
    controle_plane_network = ""
    bridge_router_ip = ""
  }
}

#####
# Security Group 
#
resource "nifcloud_security_group" "worker" {
  group_name        = "worker"
  description       = "k8s worker"
  availability_zone = var.availability_zone
}

resource "nifcloud_security_group" "egress" {
  group_name        = "egress"
  description       = "egress"
  availability_zone = var.availability_zone
}

resource "nifcloud_security_group" "router" {
  group_name        = "router"
  description       = "router"
  availability_zone = var.availability_zone
}

#####
# Instance
#
resource "nifcloud_instance" "worker" {
  count = var.number_of_worker

  instance_id       = "worker${local.delimiter}node${count.index}"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.instance_key_name
  security_group    = nifcloud_security_group.worker.group_name
  instance_type     = var.worker_type
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }

  network_interface {
    network_id = var.private_network_info.id
  }

  user_data = data.template_file.script.rendered
}

resource "nifcloud_instance" "egress" {

  instance_id       = "egress"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.instance_key_name
  security_group    = nifcloud_security_group.egress.group_name
  instance_type     = var.egress_type
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.egress_global_ip
  }

  network_interface {
    network_id = var.private_network_info.id
  }
}

#####
# LB
#
resource "nifcloud_load_balancer" "l4lb" {
  load_balancer_name = "l4lb2worker"
  accounting_type = var.accounting_type
  balancing_type = 1 // Round-Robin
  instance_port = 443
  load_balancer_port = 443
  instances = nifcloud_instance.worker[*].instance_id
}

#####
# Security Group Rule
#
resource "nifcloud_security_group_rule" "worker_from_lb" {
  security_group_names = [
    nifcloud_security_group.worker.group_name,
  ]
  type                 = "IN"
  from_port            = 443
  to_port              = 443
  protocol             = "TCP"
  cidr_ip              = nifcloud_load_balancer.l4lb.dns_name
}

resource "nifcloud_security_group_rule" "ssh_from_bastion" {
  count = var.bastion_security_group ? 1 : 0

  security_group_names = [
    nifcloud_security_group.worker.group_name,
    nifcloud_security_group.egress.group_name,
  ]
  type                 = "IN"
  from_port            = 22
  to_port              = 22
  protocol             = "TCP"
  source_security_group_name = var.bastion_security_group

  depends_on = [
    nifcloud_security_group.worker,
    nifcloud_security_group.egress,
  ]
}