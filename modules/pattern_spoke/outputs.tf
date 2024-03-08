output "resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.resource_group.name
}

output "linux_virtual_machine_name" {
  description = "The name of the Linux Virtual Machine."
  value       = module.linux_virtual_machine[*].name
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

output "windows_virtual_machine_name" {
  description = "The name of the Windows Virtual Machine."
  value       = module.windows_virtual_machine[*].name
}

output "windows_virtual_machine_admin_username" {
  description = "The password of the Windows Virtual Machine."
  value       = module.windows_virtual_machine[*].admin_username
}

output "windows_virtual_machine_admin_password" {
  description = "The password of the Windows Virtual Machine."
  value       = module.windows_virtual_machine[*].admin_password
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

output "virtual_machines" {
  description = "The virtual machines."
  value       = local.virtual_machines
}

output "address_space" {
  description = "The address space of the virtual network."
  value       = var.address_space
}

output "network_security_group_id" {
  description = "The ID of the Network Security Group."
  value       = var.network_security_group ? module.network_security_group[0].id : null
}