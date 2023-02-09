data "nifcloud_image" "ubuntu" {
  image_name = var.ubuntu_image_name
}

resource "nifcloud_private_lan" "bridge_network" {
  private_lan_name  = "bridgenetwork"
  availability_zone = var.availability_zone
  cidr_block        = var.bridge_network_cidr
  accounting_type   = var.accounting_type
}

resource "nifcloud_dhcp_config" "this" {
  ipaddress_pool {
    ipaddress_pool_start = var.dhcp_config.ipaddress_pool_start
    ipaddress_pool_stop = var.dhcp_config.ipaddress_pool_stop
  }
}

resource "nifcloud_security_group" "router" {
  group_name = "router"
  availability_zone = var.availability_zone
}

resource "nifcloud_router" "this" {
  name = "${var.unique_name}router"
  availability_zone = var.availability_zone
  security_group = nifcloud_security_group.router.group_name
  accounting_type = var.accounting_type
  type = var.router_type

  network_interface {
    network_name = nifcloud_private_lan.bridge_network.private_lan_name
    ip_address = var.router_ip_address
    dhcp = true
    dhcp_config_id = nifcloud_dhcp_config.this.id
  }
}


resource "nifcloud_security_group" "bastion" {
  group_name = "bastion"
  description       = "bastion"
  availability_zone = var.availability_zone
}

resource "nifcloud_instance" "bastion" {

  instance_id       = "bastion"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.instance_key_name
  security_group    = nifcloud_security_group.bastion.group_name
  instance_type     = var.bastion.instance_type
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.bastion.public_ip
  }

  network_interface {
    network_id = nifcloud_private_lan.bridge_network.network_id
  }
  depends_on = [
    nifcloud_router.this,
  ]
}

resource "nifcloud_security_group" "egress" {
  group_name = "egress"
  description       = "egress"
  availability_zone = var.availability_zone
}

resource "nifcloud_instance" "egress" {

  instance_id       = "egress"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.instance_key_name
  security_group    = nifcloud_security_group.egress.group_name
  instance_type     = var.egress.instance_type
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.egress.public_ip
  }

  network_interface {
    network_id = nifcloud_private_lan.bridge_network.network_id
  }
  
  depends_on = [
    nifcloud_router.this,
  ]
}

resource "nifcloud_security_group_rule" "egress_any" {
  security_group_names = [
    nifcloud_security_group.egress.group_name,
  ]
  type                 = "IN"
  from_port            = 0
  to_port              = 65535
  protocol             = "TCP"
  cidr_ip              = var.bridge_network_cidr
}
