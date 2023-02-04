
locals {
  instance_key_name = "terraform"
  k8s_instance_pool_module = "./../k8s-instance-pool"
  private_network_conf_module = "./../private-network-conf"


  ssh_port = 22
  # https://kubernetes.io/ja/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
  apiserver_port = 6443
  etcd_server_client_start = 2379
  etcd_server_client_end   = 2380
  kubelet = 10250
  kube_scheduler = 10251
  kube_controller_manager = 10252
  nodeport_service_start = 30000
  nodeport_service_end = 32767

}

module "private_network_conf" {
  source = "./../private-network-conf"

  availability_zone = var.availability_zone
  router_ip_address = var.router.ip_address 

  private_network_info = var.private_network
  dhcp_config = {
    ipaddress_pool_start = var.router.pool_ip_start
    ipaddress_pool_stop = var.router.pool_ip_stop
  }
}

module "instance_pool_worker" {
  source = "./../k8s-instance-pool"
  
  availability_zone = var.availability_zone
  pool_role = {
    full_name = "worker"
    short_name = "wrkr"
  }
  instance_key_name = local.instance_key_name
  instnce_global_ip = var.worker_gip
  private_network_info = var.private_network

  depends_on = [ module.private_network_conf ]
}

module "instance_pool_controle_plane" {
  source =  "./../k8s-instance-pool"
  
  availability_zone = var.availability_zone
  pool_role = {
    full_name = "controleplane"
    short_name = "ctrl"
  }
  instance_key_name = local.instance_key_name
  instnce_global_ip = var.controle_plane_gip
  private_network_info = var.private_network

  depends_on = [ module.private_network_conf ]
}

module "instance_pool_lb" {
  count = var.cluster_resource_only ? 1 : 0

  source = "./../k8s-instance-pool"
  
  availability_zone = var.availability_zone
  pool_role = {
    full_name = "loadbalancer"
    short_name = "lb"
  }
  instance_key_name = local.instance_key_name
  instnce_global_ip = var.lb_gip
  private_network_info = var.private_network

  depends_on = [ module.private_network_conf ]
}

module "instance_pool_bastion" {
  count = var.cluster_resource_only ? 1 : 0
  source = "./../k8s-instance-pool"
  
  availability_zone = var.availability_zone
  pool_role = {
    full_name = "bastion"
    short_name = "bstn"
  }
  instance_key_name = local.instance_key_name
  instnce_global_ip = var.bastion_gip
  private_network_info = var.private_network

  depends_on = [ module.private_network_conf ]
}

module "instance_pool_egress" {
  count = var.cluster_resource_only ? 1 : 0
  source = "./../k8s-instance-pool"
  
  availability_zone = var.availability_zone
  pool_role = {
    full_name = "egress"
    short_name = "egrs"
  }
  instance_key_name = local.instance_key_name
  instnce_global_ip = var.egress_gip
  private_network_info = var.private_network

  depends_on = [ module.private_network_conf ]
}
