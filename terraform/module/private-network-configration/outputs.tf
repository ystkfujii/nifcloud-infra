output "security_group" {
  value = nifcloud_security_group.this.group_name
}

output "private_network_id" {
  value = nifcloud_private_lan.lan.network_id
}

output "private_network_name" {
  value = nifcloud_private_lan.lan.private_lan_name
}

output "bridge_network_id" {
  value = nifcloud_private_lan.bridge.network_id
}

output "bridge_network_name" {
  value = nifcloud_private_lan.bridge.private_lan_name
}

output "bridge_network_cidr" {
  value = var.bridge_network.cidr
}
output "private_network_ip" {
  value = var.private_network.cidr
}