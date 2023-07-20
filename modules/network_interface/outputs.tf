# output "id" {
#   description = "The ID of the Virtual Network."
#   value       = azurerm_virtual_network.this.id
# }

# output "name" {
#   description = "The name of the Virtual Network."
#   value       = azurerm_virtual_network.this.name
# }

# output "resource_group_name" {
#   description = "The name of the resource group in which to create the Virtual Network."
#   value       = azurerm_virtual_network.this.resource_group_name
# }

# output "vm_password" {
#   value     = local.admin_password
#   sensitive = true
# }

# output "vm_username" {
#   value = var.admin_username
# }

# output "private_ip_address" {
#   value = azurerm_network_interface.this.private_ip_address
# }

# output "network_interface_id" {
#   value = azurerm_network_interface.this.id
# }