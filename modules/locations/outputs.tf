output "location" {
  description = "Map of information for the location. Return 'none' if location is not found."
  value       = local.location
}

output "name" {
  description = "Standard name of the location. Return 'none' if location is not found."
  value       = try(local.location.name, "none")
}

output "display_name" {
  description = "Display name of the location. Return 'none' if location is not found."
  value       = try(local.location.display_name, "none")
}

output "short_name" {
  description = "Short name of the location. Return 'none' if location is not found and null if there is no short name for this location."
  value       = try(local.location.short_name, "none")
}

output "regional_display_name" {
  description = "Regional display name of the location. Return 'none' if location is not found."
  value       = try(local.location.regional_display_name, "none")
}

output "paired_region_name" {
  description = "Paired region name of the location. Return 'none' if location is not found and null if there is no paired region name for this location."
  value       = try(local.location.paired_region_name, "none")
}