terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

locals {
  module_tags = tomap(
    {
      terraform-module-composable = "azurerm/resources/azure//modules/custom_spoke_dns"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )
}

module "locations" {
  source   = "azurerm/locations/azure"
  location = var.location
}

module "naming" {
  source = "azurerm/naming/azure"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

module "resource_group" {
  source      = "azurerm/resources/azure//modules/resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload
  instance    = var.instance
  tags        = local.tags
}

module "virtual_network" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  address_space       = var.address_space
  tags                = local.tags
}

module "subnet_inbound" {
  source                                    = "azurerm/resources/azure//modules/subnet"
  location                                  = var.location
  environment                               = var.environment
  workload                                  = "in"
  instance                                  = var.instance
  resource_group_name                       = module.resource_group.name
  virtual_network_name                      = module.virtual_network.name
  address_prefixes                          = [cidrsubnet(var.address_space[0], 1, 0)]
  private_endpoint_network_policies_enabled = true
  delegation = {
    "Microsoft.Network.dnsResolvers" = {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

module "subnet_outbound" {
  source                                    = "azurerm/resources/azure//modules/subnet"
  location                                  = var.location
  environment                               = var.environment
  workload                                  = "out"
  instance                                  = var.instance
  resource_group_name                       = module.resource_group.name
  virtual_network_name                      = module.virtual_network.name
  address_prefixes                          = [cidrsubnet(var.address_space[0], 1, 1)]
  private_endpoint_network_policies_enabled = true
  delegation = {
    "Microsoft.Network.dnsResolvers" = {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

module "private_dns_resolver" {
  source                      = "azurerm/resources/azure//modules/private_dns_resolver"
  location                    = var.location
  environment                 = var.environment
  workload                    = var.workload
  instance                    = var.instance
  resource_group_name         = module.resource_group.name
  virtual_network_id          = module.virtual_network.id
  inbound_endpoint_subnet_id  = module.subnet_inbound.id
  outbound_endpoint_subnet_id = module.subnet_outbound.id
  tags                        = local.tags
}

module "private_dns_resolver_dns_forwarding_ruleset" {
  source                                     = "azurerm/resources/azure//modules/private_dns_resolver_dns_forwarding_ruleset"
  location                                   = var.location
  environment                                = var.environment
  workload                                   = var.workload
  instance                                   = var.instance
  resource_group_name                        = module.resource_group.name
  private_dns_resolver_outbound_endpoint_ids = [module.private_dns_resolver.outbound_endpoint_id]
  virtual_network_id                         = module.virtual_network.id
  tags                                       = local.tags
}

module "private_dns_resolver_forwarding_rule" {
  source                    = "azurerm/resources/azure//modules/private_dns_resolver_forwarding_rule"
  for_each                  = { for rule in var.dns_forwarding_rules : rule.domain_name => rule }
  dns_forwarding_ruleset_id = module.private_dns_resolver_dns_forwarding_ruleset.id
  domain_name               = each.value.domain_name
  target_dns_servers        = each.value.target_dns_servers
}
