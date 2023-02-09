locals {
  west_region               = "jp-west-1"
  east_region               = "jp-east-1"
  west_az    = "west-11"
  east_az    = "east-11"
}

provider "nifcloud" {
  region = local.west_region
}

provider "nifcloud" {
  region = local.east_region
  alias  = "east"
}

#####
# Elastic IP
#
resource "nifcloud_elastic_ip" "egress_east" {

  provider = nifcloud.east

  ip_type           = false
  availability_zone = local.east_az
  description       = "egress"
}

resource "nifcloud_elastic_ip" "egress_west" {

  ip_type           = false
  availability_zone = local.west_az
  description       = "egress"
}

resource "nifcloud_elastic_ip" "bastion_west" {

  ip_type           = false
  availability_zone = local.west_az
  description       = "bastion server"
}

resource "nifcloud_elastic_ip" "bastion_east" {

  provider = nifcloud.east

  ip_type           = false
  availability_zone = local.east_az
  description       = "bastion server"
}


resource "nifcloud_key_pair" "deployer_west" {  
  key_name    = "deployerkey"
  public_key  = base64encode(file("./out/key.pub"))
  description = "memo"

}

resource "nifcloud_key_pair" "deployer_east" {  

  provider = nifcloud.east
  
  key_name    = "deployerkey"
  public_key  = base64encode(file("./out/key.pub"))
  description = "memo"
}