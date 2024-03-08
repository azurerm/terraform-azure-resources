output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "The name of the Key Vault."
  value       = azurerm_storage_account.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  value       = azurerm_storage_account.this.resource_group_name
}