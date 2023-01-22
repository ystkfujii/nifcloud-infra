locals {
  private_network_cidr = "192.168.0.0/16"
}

resource "nifcloud_private_lan" "private_lan" {
  private_lan_name  = "${var.env}${var.cluster_name}lan"
  availability_zone = var.availability_zone
  cidr_block        = local.private_network_cidr
  accounting_type   = "1"  // monthly
}
