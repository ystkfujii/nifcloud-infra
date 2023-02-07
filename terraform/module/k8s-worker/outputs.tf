output "instance_info" {
  description = "instance info"
  value       = {
    id = nifcloud_instance.worker[*].unique_id
    private_ip = nifcloud_instance.worker[*].private_ip
    public_ip = nifcloud_instance.worker[*].public_ip
  }
}

output "security_group_name" {
  value = {
    worker = nifcloud_security_group.worker.group_name
    egress = nifcloud_security_group.egress.group_name
    router = nifcloud_security_group.router.group_name
  }
}