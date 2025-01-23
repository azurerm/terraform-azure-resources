output "resource_group_name" {
  description = "The name of the resource group of the hub."
  value       = module.resource_group.name
}

output "resource_group_management_name" {
  description = "The name of the management resource group."
  value       = module.resource_group_management.name
}

output "virtual_network_name" {
  description = "The name of the virtual network of the hub."
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "The ID of the virtual network of the hub."
  value       = module.virtual_network.id
}

output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = var.key_vault ? module.key_vault[0].id : null
}

output "gateway_public_ip_address" {
  description = "The public IP address of the Gateway."
  value       = var.gateway ? module.public_ip_gateway[*].ip_address : null
}

output "gateway_id" {
  description = "The ID of the Gateway."
  value       = var.gateway ? module.gateway[0].id : null
}

output "firewall_private_ip_address" {
  description = "The private IP address of the Firewall."
  value       = (var.firewall || var.firewall_palo_alto) ? try(module.firewall[0].private_ip_address, cidrhost(cidrsubnet(var.address_space[0], 4, 6), 4)) : null
}

output "palo_alto_password" {
  description = "The password of the Palo Alto Firewall."
  value       = var.firewall_palo_alto ? module.firewall_palo_alto[0].password : null
}

output "firewall_public_ip_address" {
  description = "The public IP address of the Firewall."
  value       = var.firewall ? module.public_ip_firewall[0].ip_address : null
}

output "firewall_policy_id" {
  description = "The ID of the Firewall Policy."
  value       = var.firewall ? module.firewall_policy[0].id : null
}

output "route_table_name" {
  description = "The name of the Route Table."
  value       = (var.gateway && var.firewall) ? module.route_table_gateway[0].name : null
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace."
  value       = module.log_analytics_workspace.id
}

output "log_analytics_workspace_workspace_id" {
  description = "The resource ID of the Log Analytics Workspace."
  value       = module.log_analytics_workspace.workspace_id
}

output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = var.storage_account ? module.storage_account[0].id : null
}