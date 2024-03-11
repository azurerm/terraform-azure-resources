output "id" {
  description = "The ID of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.id
}

output "name" {
  description = "The name of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.resource_group_name
}
