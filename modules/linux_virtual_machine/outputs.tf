output "id" {
  description = "The ID of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.id
}

output "name" {
  description = "The name of the Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which the Linux Virtual Machine is created."
  value       = azurerm_linux_virtual_machine.this.resource_group_name
}

output "admin_username" {
  description = "The username of the Linux Virtual Machine."
  value       = var.admin_username
}

output "admin_password" {
  description = "The password of the Linux Virtual Machine."
  value       = local.admin_password
  sensitive   = true
}

output "private_ip_address" {
  description = "The private IP address of the Linux Virtual Machine."
  value       = azurerm_network_interface.this.private_ip_address
}

output "source_image_reference_offer" {
  description = "The offer of the source image used to create the Linux Virtual Machine."
  value       = var.source_image_reference_offer
}