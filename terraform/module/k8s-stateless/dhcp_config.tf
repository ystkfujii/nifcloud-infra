resource "nifcloud_dhcp_config" "this" {
  ipaddress_pool {
    ipaddress_pool_start = "192.168.1.1"
    ipaddress_pool_stop = "192.168.1.255"
  }
}

resource "nifcloud_security_group" "router" {
  group_name = "router"
  availability_zone = var.availability_zone
}

resource "nifcloud_router" "this" {
  name = "routertest"
  availability_zone = var.availability_zone
  security_group = nifcloud_security_group.router.group_name
  accounting_type = var.accounting_type
  type = "small"

  network_interface {
    network_name = var.private_network_info.name
    ip_address = "192.168.0.1"
    dhcp = true
    dhcp_config_id = nifcloud_dhcp_config.this.id
  }
}

