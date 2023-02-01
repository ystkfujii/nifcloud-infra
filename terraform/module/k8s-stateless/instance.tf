data "nifcloud_image" "ubuntu" {
  image_name = "Ubuntu Server 22.04 LTS"
}

#####
# Control Plane
#
resource "nifcloud_instance" "k8s_cp" {
  count = 3

  instance_id       = "k8scp${count.index}"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.key_name
  security_group    = nifcloud_security_group.k8s_cp.group_name
  instance_type     = "e-large16"
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.eip_k8s_cp[count.index]
  }

  network_interface {
    network_id = var.private_network_info.id
  }

  depends_on = [ nifcloud_router.this]
}

#####
# Node
#
resource "nifcloud_instance" "k8s_node" {
  count = 3

  instance_id       = "k8snode${count.index}"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.key_name
  security_group    = nifcloud_security_group.k8s_node.group_name
  instance_type     = "e-large16"
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.eip_k8s_node[count.index]
  }

  network_interface {
    network_id = var.private_network_info.id
  }
  depends_on = [ nifcloud_router.this]
}

#####
# Ops Server
#
resource "nifcloud_instance" "ops_server" {
  count = 1

  instance_id       = "ops${count.index}"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.key_name
  security_group    = nifcloud_security_group.ops_server.group_name
  instance_type     = "e-medium"
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.eip_ops_server[count.index]
  }

  network_interface {
    network_id = var.private_network_info.id
  }
  depends_on = [ nifcloud_router.this]
}

#####
# Proxy Server
#
resource "nifcloud_instance" "proxy_server" {
  count = 1

  instance_id       = "proxy${count.index}"
  availability_zone = var.availability_zone
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = var.key_name
  security_group    = nifcloud_security_group.proxy_server.group_name
  instance_type     = "e-medium"
  accounting_type   = var.accounting_type

  network_interface {
    network_id = "net-COMMON_GLOBAL"
    ip_address = var.eip_proxy_server[count.index]
  }

  network_interface {
    network_id = var.private_network_info.id
  }
  depends_on = [ nifcloud_router.this]
}

