terraform {
  required_providers {
    nifcloud = {
      source = "nifcloud/nifcloud"
    }
  }
}

provider "nifcloud" {
  region = "jp-east-1"
}

resource "nifcloud_instance" "web" {
  instance_id       = "web001"
  availability_zone = "east-12"
  image_id          = data.nifcloud_image.ubuntu.id
  key_name          = "webkey"
  security_group    = nifcloud_security_group.web.group_name
  instance_type     = "small"
  accounting_type   = "2"

  network_interface {
    network_id = "je12devnrnlan"
  }

  network_interface {
    network_id = "kubernetes"
  }
}

resource "nifcloud_security_group" "web" {
  group_name        = "webfw"
  availability_zone = "east-12"
}

data "nifcloud_image" "ubuntu" {
  image_name = "Ubuntu Server 20.04 LTS"
}
