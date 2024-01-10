module "azure_location" {
  source   = "../"
  location = "West Europe"
}

output "location" {
  value = module.azure_location.location
}
# location                       = {
#     display_name          = "West Europe"
#     name                  = "westeurope"
#     paired_region_name    = "northeurope"
#     regional_display_name = "(Europe) West Europe"
#     short_name            = "we"
# }

module "azure_fake_location" {
  source   = "../"
  location = "Test Europe"
}

output "fake_location" {
  value = module.azure_fake_location.location
}
# location = "none"