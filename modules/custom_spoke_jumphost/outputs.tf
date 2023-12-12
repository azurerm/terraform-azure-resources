output "resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.resource_group.name
}

output "virtual_network_name" {
  description = "The name of the virtual network of the spoke."
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "The ID of the spoke."
  value       = module.virtual_network.id
}

output "virtual_machines" {
  description = "The virtual machines."
  value       = local.virtual_machines
}

output "address_space" {
  description = "The address space of the virtual network."
  value       = var.address_space
}