locals {
  west_region               = "west-1"
  east_region               = "east-1"
  west_az    = "west-11"
  east_az    = "east-11"
  env                  = "dev"
}

provider "nifcloud" {
  region = "jp-west-1"
  alias  = "west"
}

provider "nifcloud" {
  region = "jp-east-1"
  alias  = "east"
}


module "k8s_stateful_east" {
  source = "../../module/k8s-stateful"

  providers = {
    nifcloud = nifcloud.east
  }

  availability_zone = local.east_az
  private_network_cidr = "192.168.0.0/23"
  elastic_ip = {
    bastion = 0
    controle_plane = 0
    egress = 0
    lb = 0
    worker = 2
  }
}

module "k8s_stateful_west" {
  source = "../../module/k8s-stateful"

  providers = {
    nifcloud = nifcloud.west
  }

  availability_zone = local.west_az
  private_network_cidr = "192.168.0.0/23"

  elastic_ip = {
    bastion = 1
    controle_plane = 3
    egress = 1
    lb = 1
    worker = 2
  }

}

