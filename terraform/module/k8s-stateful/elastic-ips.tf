#####
# Egress
#
resource "nifcloud_elastic_ip" "egress" {
  count = var.elastic_ip.egress

  ip_type           = false
  availability_zone = var.availability_zone
  description       = "egress ${count.index}"
}

#####
# Bastion Server
#
resource "nifcloud_elastic_ip" "bastion" {
  count = var.elastic_ip.bastion

  ip_type           = false
  availability_zone = var.availability_zone
  description       = "bastion server"
}

#####
# Control Plane
#
resource "nifcloud_elastic_ip" "k8s_cp" {
  count = var.elastic_ip.controle_plane
  
  ip_type           = false
  availability_zone = var.availability_zone
  description       = "k8s_cp_${count.index}"
}

#####
# LB 
#
resource "nifcloud_elastic_ip" "k8s_lb" {
  count = var.elastic_ip.lb

  ip_type           = false
  availability_zone = var.availability_zone
  description       = "k8s_lb_${count.index}"
}

#####
# Node
#
resource "nifcloud_elastic_ip" "k8s_worker" {
  count = var.elastic_ip.worker

  ip_type           = false
  availability_zone = var.availability_zone
  description       = "k8s_worker_${count.index}"
}
