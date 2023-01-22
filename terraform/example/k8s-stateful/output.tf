output "private_network_id" {
  description = "private network id"
  value       = module.k8s_stateful.private_network_id
}

output "private_network_name" {
  description = "private network"
  value       = module.k8s_stateful.private_network_name
}

output "eip_proxy_server" {
  description = "eip for proxy"
  value       = module.k8s_stateful.eip_proxy
}

output "eip_ops_server" {
  description = "eip for ops server"
  value       = module.k8s_stateful.eip_ops 
}

output "eip_k8s_cp" {
  description = "eip for k8s controle plane"
  value       = module.k8s_stateful.eip_k8s_cp 
}

output "eip_k8s_node" {
  description = "eip for k8s node"
  value       = module.k8s_stateful.eip_k8s_node 
}