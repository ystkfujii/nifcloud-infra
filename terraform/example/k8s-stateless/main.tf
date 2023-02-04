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

}

provider "nifcloud" {
  region     = local.east_region
  alias      = "east"
}

provider "nifcloud" {
  region     = local.west_region
  alias      = "west"
}

module "k8s_stateless_east" {
  source = "../../module/k8s-stateless"

  providers = {
    nifcloud = nifcloud.east
  }

  availability_zone = local.east_az

  controle_plane_gip = data.terraform_remote_state.k8s_stateful.outputs.controle_plane_gip_east
  worker_gip = data.terraform_remote_state.k8s_stateful.outputs.worker_gip_east
  lb_gip = data.terraform_remote_state.k8s_stateful.outputs.lb_gip_east

  egress_gip = data.terraform_remote_state.k8s_stateful.outputs.egress_gip_east
  bastion_gip = data.terraform_remote_state.k8s_stateful.outputs.bastion_gip_east

  private_network = data.terraform_remote_state.k8s_stateful.outputs.private_network_east
  router = {
    ip_address = "192.168.0.1"
    pool_ip_start = "192.168.0.1"
    pool_ip_stop = "192.168.0.255"
  }
}

module "k8s_stateless_west" {
  source = "../../module/k8s-stateless"

  providers = {
    nifcloud = nifcloud.west
  }

  availability_zone = local.west_az
  controle_plane_gip = data.terraform_remote_state.k8s_stateful.outputs.controle_plane_gip_west
  worker_gip = data.terraform_remote_state.k8s_stateful.outputs.worker_gip_west
  lb_gip = data.terraform_remote_state.k8s_stateful.outputs.lb_gip_west
  egress_gip = data.terraform_remote_state.k8s_stateful.outputs.egress_gip_west
  bastion_gip = data.terraform_remote_state.k8s_stateful.outputs.bastion_gip_west

  private_network = data.terraform_remote_state.k8s_stateful.outputs.private_network_west
  router = {
    ip_address  = "192.168.1.1"
    pool_ip_start = "192.168.1.1"
    pool_ip_stop = "192.168.1.255"
  }
}