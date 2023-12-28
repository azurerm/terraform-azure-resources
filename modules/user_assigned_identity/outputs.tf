output "id" {
  description = "The ID of the User Assigned Identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "name" {
  description = "The name of the User Assigned Identity."
  value       = azurerm_user_assigned_identity.this.name
}

output "uuid" {
  description = "The UUID of the User Assigned Identity."
  value       = azurerm_user_assigned_identity.this.principal_id
}