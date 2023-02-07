output "instance_info" {
  description = "instance info"
  value       = {
    id = nifcloud_instance.controle_plane[*].unique_id
    private_ip = nifcloud_instance.controle_plane[*].private_ip
    public_ip = nifcloud_instance.controle_plane[*].public_ip
  }
}

output "group_name" {
  value = {
    controle_plane = nifcloud_security_group.controle_plane.group_name
  }
}