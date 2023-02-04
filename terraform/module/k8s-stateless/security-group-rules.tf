
resource "nifcloud_security_group_rule" "apiserver_from_all" {
  count = var.cluster_resource_only ? 1 : 0

  security_group_names = [
    module.instance_pool_lb[0].group_name,
  ]
  type                 = "IN"
  from_port            = local.apiserver_port
  to_port              = local.apiserver_port
  protocol             = "TCP"
  cidr_ip              = "0.0.0.0/0"
}

resource "nifcloud_security_group_rule" "apiserver_from_lb" {
  count = var.cluster_resource_only ? 1 : 0
  security_group_names = [
    module.instance_pool_controle_plane.group_name,
  ]
  type                 = "IN"
  from_port            = local.apiserver_port
  to_port              = local.apiserver_port
  protocol             = "TCP"
  cidr_ip              = "${module.instance_pool_lb[0].instance_info.private_ip}/32"
}

/*
resource "nifcloud_security_group_rule" "etcd_from_apiserver" {
  security_group_names = [
    nifcloud_security_group.k8s_cp.group_name,
  ]
  type                 = "IN"
  from_port            = local.etcd_server_client_start
  to_port              = local.etcd_server_client_end
  protocol             = "TCP"
  source_security_group_name = nifcloud_security_group.k8s_cp.group_name
}
*/

resource "nifcloud_security_group_rule" "kubelet_from_control_plane" {
  security_group_names = [
    module.instance_pool_worker.group_name,
  ]
  type                 = "IN"
  from_port            = local.kubelet
  to_port              = local.kubelet
  protocol             = "TCP"
  source_security_group_name = module.instance_pool_controle_plane.group_name
}


/*
resource "nifcloud_security_group_rule" "kubecheduler_from_control_plane" {
  security_group_names = [
    nifcloud_security_group.k8s_cp.group_name,
  ]
  type                 = "IN"
  from_port            = local.kube_scheduler
  to_port              = local.kube_scheduler
  protocol             = "TCP"
  source_security_group_name = nifcloud_security_group.k8s_cp.group_name
}
resource "nifcloud_security_group_rule" "kube_controller_manager_from_control_plane" {
  security_group_names = [
    nifcloud_security_group.k8s_cp.group_name,
  ]
  type                 = "IN"
  from_port            = local.kube_controller_manager
  to_port              = local.kube_controller_manager
  protocol             = "TCP"
  source_security_group_name = nifcloud_security_group.k8s_cp.group_name
}
*/

resource "nifcloud_security_group_rule" "nodeportservice_from_all" {
  security_group_names = [
    module.instance_pool_worker.group_name,
  ]
  type                 = "IN"
  from_port            = local.nodeport_service_start
  to_port              = local.nodeport_service_end
  protocol             = "TCP"
  cidr_ip              = "0.0.0.0/0"
}

resource "nifcloud_security_group_rule" "ssh_from_bastion" {
  count = var.cluster_resource_only ? 1 : 0
  security_group_names = [
    module.instance_pool_worker.group_name,
    module.instance_pool_controle_plane.group_name,
  ]
  type                 = "IN"
  from_port            = local.ssh_port
  to_port              = local.ssh_port
  protocol             = "TCP"
  source_security_group_name = module.instance_pool_bastion[0].group_name
}


resource "nifcloud_security_group_rule" "ssh2_from_bastion" {
  count = var.cluster_resource_only ? 1 : 0
  security_group_names = [
    module.instance_pool_lb[0].group_name,
    module.instance_pool_egress[0].group_name,
  ]
  type                 = "IN"
  from_port            = local.ssh_port
  to_port              = local.ssh_port
  protocol             = "TCP"
  source_security_group_name = module.instance_pool_bastion[0].group_name
}

resource "nifcloud_security_group_rule" "ssh_from_fujii_dev" {
  security_group_names = [
    module.instance_pool_worker.group_name,
    module.instance_pool_controle_plane.group_name,
  ]
  type                 = "IN"
  from_port            = local.ssh_port
  to_port              = local.ssh_port
  protocol             = "TCP"
  cidr_ip              = "164.70.16.71"
}

resource "nifcloud_security_group_rule" "ssh2_from_fujii_dev" {
  count = var.cluster_resource_only ? 1 : 0
  security_group_names = [
    module.instance_pool_lb[0].group_name,
    module.instance_pool_egress[0].group_name,
    module.instance_pool_bastion[0].group_name,
  ]
  type                 = "IN"
  from_port            = local.ssh_port
  to_port              = local.ssh_port
  protocol             = "TCP"
  cidr_ip              = "164.70.16.71"
}
