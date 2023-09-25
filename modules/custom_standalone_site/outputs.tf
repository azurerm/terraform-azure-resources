output "resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.resource_group.name
}

output "linux_virtual_machine_admin_username" {
  description = "The password of the Linux Virtual Machine."
  value       = module.linux_virtual_machine[*].admin_username
}

output "linux_virtual_machine_admin_password" {
  description = "The password of the Linux Virtual Machine."
  value       = module.linux_virtual_machine[*].admin_password
  sensitive   = true
}

output "virtual_network_name" {
  description = "The name of the virtual network of the spoke."
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "The ID of the virtual network of the spoke."
  value       = module.virtual_network.id
}