output "egress_gip_east" {
  value = nifcloud_elastic_ip.egress_east.public_ip
}
output "egress_gip_west" {
  value = nifcloud_elastic_ip.egress_west.public_ip
}

output "bastion_gip_east" {
  value = nifcloud_elastic_ip.bastion_east.public_ip
}

output "bastion_gip_west" {
  value = nifcloud_elastic_ip.bastion_west.public_ip
}
