output "id" {
  description = "The ID of the bastion."
  value       = azurerm_bastion_host.this.id
}

output "name" {
  description = "The name of the bastion."
  value       = azurerm_bastion_host.this.name
}
