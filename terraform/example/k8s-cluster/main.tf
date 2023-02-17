data "terraform_remote_state" "k8s_stateful" {
  backend = "local"

  config = {
    path = "./../k8s-stateful/terraform.tfstate"
  }
}

locals {
  west_region           = "jp-west-1"
  east_region           = "jp-east-1"
  west_az               = "west-11"
  east_az               = "east-11"

  instance_key_name     = "deployerkey"
  bridge_network_cidr   = "192.168.1.0/24"

  ###
  # bridge network
  bastion_instance_type = "e-medium"
  egress_instance_type  = "e-medium"
  ## - west
  router_ip_address_west    = "192.168.1.129"  // west from 192.168.1.129
  ipaddress_pool_start_west = "192.168.1.130"
  ipaddress_pool_stop_west  = "192.168.1.255" 
  ## - east
  router_ip_address_east    = "192.168.1.1"
  ipaddress_pool_start_east = "192.168.1.2"
  ipaddress_pool_stop_east  = "192.168.1.127" // east still 192.168.1.127

  ###
  # controle plane
  kubectl_port = 6443
  cp_instance_type = "e-large16"

  ###
  # worker
  nodeport_ip_from = 30000
  nodeport_ip_to = 32767
  worker_instance_type = "e-large16"
}

#####
# Provider
#
provider "nifcloud" {
  region     = local.east_region
}

provider "nifcloud" {
  region     = local.west_region
  alias      = "west"
}

#####
# Bridge Network
#

# west
module "bridge_network_west" {
  source = "../../module/bridge-network"
  providers = {
    nifcloud = nifcloud.west
  }

  availability_zone = local.west_az
  unique_name = "wbrdg1"

  bridge_network_cidr = local.bridge_network_cidr
  instance_key_name = local.instance_key_name

  router_ip_address = local.router_ip_address_west
  dhcp_config = {
    ipaddress_pool_start = local.ipaddress_pool_start_west
    ipaddress_pool_stop = local.ipaddress_pool_stop_west
  }

  bastion = {
    public_ip = data.terraform_remote_state.k8s_stateful.outputs.bastion_gip_west
    instance_type = local.bastion_instance_type
  }
  egress = {
    public_ip = data.terraform_remote_state.k8s_stateful.outputs.egress_gip_west
    instance_type = local.egress_instance_type
  }
}

# east
module "bridge_network_east" {
  source = "../../module/bridge-network"

  availability_zone = local.east_az
  unique_name = "ebrdg1"

  bridge_network_cidr = local.bridge_network_cidr
  instance_key_name = local.instance_key_name

  router_ip_address = local.router_ip_address_east
  dhcp_config = {
    ipaddress_pool_start = local.ipaddress_pool_start_east
    ipaddress_pool_stop = local.ipaddress_pool_stop_east
  }

  bastion = {
    public_ip = data.terraform_remote_state.k8s_stateful.outputs.bastion_gip_east
    instance_type = local.bastion_instance_type
  }
  egress = {
    public_ip = data.terraform_remote_state.k8s_stateful.outputs.egress_gip_east
    instance_type = local.egress_instance_type
  }
}

#####
# Control Plane
#

# east
module "k8s_controle_plane_east" {
  source = "../../module/k8s-component"

  availability_zone = local.east_az
  unique_name = "ecp1"

  instance_key_name = local.instance_key_name
  instance_type = local.cp_instance_type

  instance_count = 3
  instance_listen_port = {
    from = local.kubectl_port
    to = local.kubectl_port
  }

  bridge_network_cidr = local.bridge_network_cidr
  bridge_network_id = module.bridge_network_east.network_id

  depends_on = [
    module.bridge_network_east,
  ]
}

#####
# Worker
#

# east
module "k8s_worker_east" {
  source = "../../module/k8s-component"

  availability_zone = local.east_az
  unique_name = "ewk1"

  instance_key_name = local.instance_key_name

  instance_count = 2
  instance_type = local.worker_instance_type
  instance_listen_port = {
    from = local.nodeport_ip_from
    to = local.nodeport_ip_to
  }

  bridge_network_cidr = local.bridge_network_cidr
  bridge_network_id = module.bridge_network_east.network_id

  depends_on = [
    module.bridge_network_east,
  ]
}

# west
module "k8s_worker_west" {
  source = "../../module/k8s-component"
  providers = {
    nifcloud = nifcloud.west
  }

  availability_zone = local.west_az
  unique_name = "wwk1"

  instance_key_name = local.instance_key_name
  instance_type = local.worker_instance_type

  instance_count = 2
  instance_listen_port = {
    from = local.nodeport_ip_from
    to = local.nodeport_ip_to
  }

  bridge_network_cidr = local.bridge_network_cidr
  bridge_network_id = module.bridge_network_west.network_id

  depends_on = [
    module.bridge_network_west,
  ]
}
