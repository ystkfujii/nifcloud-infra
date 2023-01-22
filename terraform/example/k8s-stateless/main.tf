data "terraform_remote_state" "k8s_stateful" {
  backend = "local"

  config = {
    path = "./../k8s-stateful/terraform.tfstate"
  }
}

locals {
  region               = "jp-west-1"
  availability_zone    = "west-11"
  env                  = "dev"
}

provider "nifcloud" {
  region     = local.region
}

module "k8s_stateless" {
  source = "../../module/k8s-stateless"

  env               = local.env
  key_name = "terraform"           // TODO !!!!!!!!!
  availability_zone = local.availability_zone
  private_network_info = {
    id = data.terraform_remote_state.k8s_stateful.outputs.private_network_id
    name = data.terraform_remote_state.k8s_stateful.outputs.private_network_name
  }
  eip_k8s_cp = data.terraform_remote_state.k8s_stateful.outputs.eip_k8s_cp
  eip_k8s_node = data.terraform_remote_state.k8s_stateful.outputs.eip_k8s_node
  eip_ops_server = data.terraform_remote_state.k8s_stateful.outputs.eip_ops_server
  eip_proxy_server = data.terraform_remote_state.k8s_stateful.outputs.eip_proxy_server
}
