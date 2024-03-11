output "id" {
  description = "The ID of the Backup Policy VM."
  value       = azurerm_backup_policy_vm.this.id
}

output "name" {
  description = "The name of the Backup Policy VM."
  value       = azurerm_backup_policy_vm.this.name
}
