terraform {
  required_version = ">= 1.3.7, < 2.0.0"

  required_providers {
    nifcloud = {
      //source  = "terraform.local/local/nifcloud"
      source  = "nifcloud/nifcloud"
      version = "1.7.0"
    }
  }
}