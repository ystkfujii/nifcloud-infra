
locals {
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

resource "nifcloud_security_group_rule" "apiserver_from_all" {
  security_group_names = [
    nifcloud_security_group.k8s_cp.group_name,
  ]
  type                 = "IN"
  from_port            = local.apiserver_port
  to_port              = local.apiserver_port
  protocol             = "TCP"
  cidr_ip              = "0.0.0.0/0"
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
    //nifcloud_security_group.k8s_cp.group_name,
    nifcloud_security_group.k8s_node.group_name,
  ]
  type                 = "IN"
  from_port            = local.kubelet
  to_port              = local.kubelet
  protocol             = "TCP"
  source_security_group_name = nifcloud_security_group.k8s_cp.group_name
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
    nifcloud_security_group.k8s_node.group_name,
  ]
  type                 = "IN"
  from_port            = local.nodeport_service_start
  to_port              = local.nodeport_service_end
  protocol             = "TCP"
  cidr_ip              = "0.0.0.0/0"
}

resource "nifcloud_security_group_rule" "ssh_from_ops" {
  security_group_names = [
    nifcloud_security_group.k8s_cp.group_name,
    nifcloud_security_group.k8s_node.group_name,
    nifcloud_security_group.proxy_server.group_name,
  ]
  type                 = "IN"
  from_port            = local.ssh_port
  to_port              = local.ssh_port
  protocol             = "TCP"
  source_security_group_name = nifcloud_security_group.ops_server.group_name
}

resource "nifcloud_security_group_rule" "ssh_from_fujii_dev" {
  security_group_names = [
    nifcloud_security_group.k8s_cp.group_name,
    nifcloud_security_group.k8s_node.group_name,
    nifcloud_security_group.proxy_server.group_name,
  ]
  type                 = "IN"
  from_port            = local.ssh_port
  to_port              = local.ssh_port
  protocol             = "TCP"
  cidr_ip              = "164.70.16.71"
}
