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
resource "nifcloud_security_group" "this" {
  group_name        = var.pool_role.full_name
  description       = "for k8s ${var.pool_role.full_name}"
  availability_zone = var.availability_zone
}

#####
# Instance Pool
#
resource "nifcloud_instance" "this" {
  count = length(var.instnce_global_ip)

  instance_id       = "${var.pool_role.short_name}${local.delimiter}node${count.index}"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.instance_key_name
  security_group    = nifcloud_security_group.this.group_name
  instance_type     = var.instance_type
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.instnce_global_ip[count.index]
  }

  network_interface {
    network_id = var.private_network_info.id
  }
}

