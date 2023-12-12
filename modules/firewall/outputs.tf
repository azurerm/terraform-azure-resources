output "id" {
  description = "The ID of the Firewall."
  value       = azurerm_firewall.this.id
}

output "name" {
  description = "The name of the Firewall."
  value       = azurerm_firewall.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the Firewall."
  value       = azurerm_firewall.this.resource_group_name
}

output "private_ip_address" {
  description = "The private IP address of the Firewall."
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}