output "resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.resource_group.name
}

output "gateway_public_ip_address" {
  description = "The public IP address of the Gateway."
  value       = var.gateway ? module.public_ip_gateway[0].ip_address : null
}

output "gateway_id" {
  description = "The ID of the Virtual Network Gateway."
  value       = var.gateway ? module.gateway[0].id : null
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