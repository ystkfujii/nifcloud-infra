output "private_network_east" {
  description = "private network info"
  value       = {
    id = module.k8s_stateful_east.private_network_id
    name = module.k8s_stateful_east.private_network_name
  }
}

output "controle_plane_gip_east" {
  value = module.k8s_stateful_east.controle_plane_gip
}

output "worker_gip_east" {
  value = module.k8s_stateful_east.worker_gip
}

output "egress_gip_east" {
  value = module.k8s_stateful_east.egress_gip
}
output "lb_gip_east" {
  value = module.k8s_stateful_east.lb_gip
}
output "bastion_gip_east" {
  value = module.k8s_stateful_east.bastion_gip
}

output "private_network_west" {
  description = "private network info"
  value       = {
    id = module.k8s_stateful_west.private_network_id
    name = module.k8s_stateful_west.private_network_name
  }
}

output "controle_plane_gip_west" {
  value = module.k8s_stateful_west.controle_plane_gip
}

output "worker_gip_west" {
  value = module.k8s_stateful_west.worker_gip
}

output "egress_gip_west" {
  value = module.k8s_stateful_west.egress_gip
}
output "lb_gip_west" {
  value = module.k8s_stateful_west.lb_gip
}
output "bastion_gip_west" {
  value = module.k8s_stateful_west.bastion_gip
}
