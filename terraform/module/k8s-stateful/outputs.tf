output "private_network_id" {
  description = "private network id"
  value       = nifcloud_private_lan.private_lan.network_id
}

output "private_network_name" {
  description = "private network"
  value       = nifcloud_private_lan.private_lan.private_lan_name
}

output "eip_proxy" {
  description = "eip for proxy"
  value       = nifcloud_elastic_ip.proxy[*].public_ip 
}

output "eip_ops" {
  description = "eip for ops server"
  value       = nifcloud_elastic_ip.ops_server[*].public_ip 
}

output "eip_k8s_cp" {
  description = "eip for k8s controle plane"
  value       = nifcloud_elastic_ip.k8s_cp[*].public_ip 
}

output "eip_k8s_node" {
  description = "eip for k8s node"
  value       = nifcloud_elastic_ip.k8s_node[*].public_ip 
}

