output "id" {
  description = "The ID of the Subnet NSG Association."
  value       = azurerm_subnet_network_security_group_association.this.id
}