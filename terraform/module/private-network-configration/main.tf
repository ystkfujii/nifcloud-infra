resource "nifcloud_dhcp_config" "this" {
  ipaddress_pool {
    ipaddress_pool_start = var.dhcp_config.ipaddress_pool_start
    ipaddress_pool_stop = var.dhcp_config.ipaddress_pool_stop
  }
}

resource "nifcloud_security_group" "this" {
  group_name = "${var.unique_name}router"
  availability_zone = var.availability_zone
}

resource "nifcloud_private_lan" "lan" {
  private_lan_name  = "${var.unique_name}lan"
  availability_zone = var.availability_zone
  cidr_block        = var.private_network.cidr
  accounting_type   = var.accounting_type
}

resource "nifcloud_private_lan" "bridge" {
  private_lan_name  = "${var.unique_name}bridge"
  availability_zone = var.availability_zone
  cidr_block        = var.bridge_network.cidr
  accounting_type   = var.accounting_type
}

resource "nifcloud_route_table" "r" {
  route {
    cidr_block = var.controle_plane_network
    ip_address = var.next_hop
  }

  route {
    cidr_block = var.private_network.cidr
    network_id = nifcloud_private_lan.lan.network_id
  }
}

resource "nifcloud_router" "this" {
  name = "${var.unique_name}router"
  availability_zone = var.availability_zone
  security_group = nifcloud_security_group.this.group_name
  accounting_type = var.accounting_type
  type = var.router_type

  network_interface {
    network_name = nifcloud_private_lan.lan.private_lan_name
    ip_address = var.private_network.router_ip_address
    dhcp = true
    dhcp_config_id = nifcloud_dhcp_config.this.id
  }

  network_interface {
    network_name = nifcloud_private_lan.bridge.private_lan_name
    ip_address = var.bridge_network.router_ip_address
    dhcp = false
  }
}


