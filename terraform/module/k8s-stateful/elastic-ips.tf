#####
# Proxy
#
resource "nifcloud_elastic_ip" "proxy" {
  count = 1

  ip_type           = false
  availability_zone = var.availability_zone
  description       = "proxy_${count.index}"
}

#####
# Ops Server
#
resource "nifcloud_elastic_ip" "ops_server" {
  count = 1

  ip_type           = false
  availability_zone = var.availability_zone
  description       = "ops_server"
}

#####
# Control Plane
#
resource "nifcloud_elastic_ip" "k8s_cp" {
  count = 3
  
  ip_type           = false
  availability_zone = var.availability_zone
  description       = "k8s_cp_${count.index}"
}

#####
# LB 
#
resource "nifcloud_elastic_ip" "k8s_lb" {
  count = 1

  ip_type           = false
  availability_zone = var.availability_zone
  description       = "k8s_lb_${count.index}"
}

#####
# Node
#
resource "nifcloud_elastic_ip" "k8s_node" {
  count = 3
  ip_type           = false
  availability_zone = var.availability_zone
  description       = "k8s_node_${count.index}"
}
