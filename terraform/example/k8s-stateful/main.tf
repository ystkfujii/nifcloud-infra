locals {
  region               = "jp-west-1"
  availability_zone    = "west-11"
  env                  = "dev"
}

provider "nifcloud" {
  region     = local.region
}

module "k8s_stateful" {
  source = "../../module/k8s-stateful"

  env               = local.env
  cluster_name      = "test"
  availability_zone = local.availability_zone
}
