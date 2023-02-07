data "terraform_remote_state" "k8s_stateful" {
  backend = "local"

  config = {
    path = "./../k8s-stateful/terraform.tfstate"
  }
}

locals {
  west_region               = "jp-west-1"
  east_region               = "jp-east-1"
  west_az    = "west-11"
  east_az    = "east-11"

  instance_key_name = "terraform"
}

data "nifcloud_image" "ubuntu" {
  image_name = "Ubuntu Server 22.04 LTS"
}

provider "nifcloud" {
  region     = local.east_region
  alias      = "east"
}

provider "nifcloud" {
  region     = local.west_region
}


module "private_network_configration_east" {
  source = "../../module/private-network-configration"

  providers = {
    nifcloud = nifcloud.east
  }
  availability_zone = local.east_az
  unique_name = "east"

  bridge_network = {
    cidr = "192.168.0.0/24"
    router_ip_address = "192.168.0.1"
  }

  private_network = {
    cidr = "192.168.1.0/24"
    router_ip_address = "192.168.1.1"
  }

  dhcp_config = {
    ipaddress_pool_start = "192.168.1.0"
    ipaddress_pool_stop = "192.168.1.255"
  }
}

module "private_network_configration_west" {
  source = "../../module/private-network-configration"

  availability_zone = local.west_az
  unique_name = "west"
  bridge_network = {
    cidr = "192.168.0.0/24"
    router_ip_address = "192.168.0.2"
  }

  private_network = {
    cidr = "192.168.2.0/24"
    router_ip_address = "192.168.2.1"
  }
  dhcp_config = {
    ipaddress_pool_start = "192.168.2.0"
    ipaddress_pool_stop = "192.168.2.255"
  }
}

resource "nifcloud_security_group" "bastion" {
  group_name        = "bastion"
  description       = "bastion"
  availability_zone = local.west_az
}

resource "nifcloud_instance" "bastion_west" {

  instance_id       = "bastion"
  availability_zone = local.west_az
  image_id          = data.nifcloud_image.ubuntu.image_id
  key_name          = local.instance_key_name
  security_group    = nifcloud_security_group.bastion.group_name
  instance_type     = "e-medium"
  accounting_type   = "1"

  network_interface {
    network_id = "net-COMMON_GLOBAL"
  }

  network_interface {
    network_id = module.private_network_configration_west.private_network_id
  }

  depends_on = [
    module.private_network_configration_west
  ]
}

module "k8s_worker_east" {
  source = "../../module/k8s-worker"
  providers = {
    nifcloud = nifcloud.east
  }

  availability_zone = local.east_az
  instance_key_name = local.instance_key_name // TODO
  private_network_info = {
    id = module.private_network_configration_east.private_network_id
    name = module.private_network_configration_east.private_network_name
  }

  bastion_security_group = null
  egress_global_ip = data.terraform_remote_state.k8s_stateful.outputs.egress_gip_east

  number_of_worker = 2

  controle_plane_network = module.private_network_configration_west.private_network_cidr
  bridge_router_ip = module.private_network_configration_east.bridge_network_ip

  depends_on = [
    module.private_network_configration_east
  ]
}

module "k8s_worker_west" {
  source = "../../module/k8s-worker"

  availability_zone = local.west_az
  instance_key_name = local.instance_key_name // TODO
  private_network_info = {
    id = module.private_network_configration_west.private_network_id
    name = module.private_network_configration_west.private_network_name
  }

  bastion_security_group = nifcloud_security_group.bastion.group_name
  egress_global_ip = data.terraform_remote_state.k8s_stateful.outputs.egress_gip_west

  number_of_worker = 2
  controle_plane_network = module.private_network_configration_west.private_network_cidr
  bridge_router_ip = module.private_network_configration_west.bridge_network_ip

  depends_on = [
    module.private_network_configration_west
  ]
}


module "k8s_controle_plane_west" {
  source = "../../module/k8s-controle-plane"

  availability_zone = local.west_az
  instance_key_name = local.instance_key_name // TODO
  private_network_info = {
    id = module.private_network_configration_west.private_network_id
    name = module.private_network_configration_west.private_network_name
  }
  bastion_security_group = nifcloud_security_group.bastion.group_name
  number_of_controle_plane = 3

  depends_on = [
    module.private_network_configration_west
  ]
}