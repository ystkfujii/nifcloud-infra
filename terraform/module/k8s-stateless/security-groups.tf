#####
# Ops Server
#
resource "nifcloud_security_group" "ops_server" {
  group_name        = "${var.env}ops"
  description       = "for ops server"
  availability_zone = var.availability_zone
}

#####
# Control Plane
#
resource "nifcloud_security_group" "k8s_cp" {
  group_name        = "${var.env}cp"
  description       = "for k8s control plne"
  availability_zone = var.availability_zone
}

#####
# Node
#
resource "nifcloud_security_group" "k8s_node" {
  group_name        = "${var.env}node"
  description       = "for k8s node"
  availability_zone = var.availability_zone
}

#####
# Proxy Server
#
resource "nifcloud_security_group" "proxy_server" {
  group_name        = "${var.env}pry"
  description       = "for proxy server"
  availability_zone = var.availability_zone
}