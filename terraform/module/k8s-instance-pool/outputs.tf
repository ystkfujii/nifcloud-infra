output "instance_info" {
  description = "instance info"
  value       = {
    id = nifcloud_instance.this[*].unique_id
    private_ip = nifcloud_instance.this[*].private_ip
    public_ip = nifcloud_instance.this[*].public_ip
  }
}

output "group_name" {
  value = nifcloud_security_group.this.group_name
}