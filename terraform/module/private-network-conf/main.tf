resource "nifcloud_dhcp_config" "this" {
  ipaddress_pool {
    ipaddress_pool_start = var.dhcp_config.ipaddress_pool_start
    ipaddress_pool_stop = var.dhcp_config.ipaddress_pool_stop
  }
}

resource "nifcloud_security_group" "this" {
  group_name = "router"
  availability_zone = var.availability_zone
}

resource "nifcloud_router" "this" {
  name = "router"
  availability_zone = var.availability_zone
  security_group = nifcloud_security_group.this.group_name
  accounting_type = var.accounting_type
  type = var.router_type

  network_interface {
    network_name = var.private_network_info.name
    ip_address = var.router_ip_address
    dhcp = true
    dhcp_config_id = nifcloud_dhcp_config.this.id
  }
}
