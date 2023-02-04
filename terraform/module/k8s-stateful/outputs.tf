output "private_network_id" {
  description = "private network id"
  value       = nifcloud_private_lan.private_lan.network_id
}

output "private_network_name" {
  description = "private network"
  value       = nifcloud_private_lan.private_lan.private_lan_name
}

output "egress_gip" {
  description = "eip for egress"
  value       = nifcloud_elastic_ip.egress[*].public_ip 
}

output "lb_gip" {
  description = "eip for lb"
  value       = nifcloud_elastic_ip.k8s_lb[*].public_ip 
}

output "bastion_gip" {
  description = "eip for ops server"
  value       = nifcloud_elastic_ip.bastion[*].public_ip 
}

output "controle_plane_gip" {
  description = "eip for k8s controle plane"
  value       = nifcloud_elastic_ip.k8s_cp[*].public_ip 
}

output "worker_gip" {
  description = "eip for worker node"
  value       = nifcloud_elastic_ip.k8s_worker[*].public_ip 
}

