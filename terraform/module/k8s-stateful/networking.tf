resource "nifcloud_private_lan" "private_lan" {
  private_lan_name  = "lan"
  availability_zone = var.availability_zone
  cidr_block        = var.private_network_cidr
  accounting_type   = "1"  // monthly
}
