locals {
  west_region               = "jp-west-1"
  east_region               = "jp-east-1"
  west_az    = "west-11"
  east_az    = "east-11"

  instance_key_name = "terraform"
}

provider "nifcloud" {
  region     = local.west_region
}

module "sshkey_gen_west" {
  source = "../../module/sshkey"

}