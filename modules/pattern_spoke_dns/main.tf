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
      terraform-azurerm-composable-level2 = "pattern_spoke_dns"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )
}

module "resource_group" {
  source      = "../resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload
  instance    = var.instance
  tags        = local.tags
}

module "virtual_network" {
  source              = "../virtual_network"
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  address_space       = var.address_space
  tags                = local.tags
}

module "subnet_inbound" {
  source               = "../subnet"
  location             = var.location
  environment          = var.environment
  workload             = "in"
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 1, 0)]
  delegation = {
    "Microsoft.Network.dnsResolvers" = {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

module "routing_inbound" {
  source              = "../pattern_routing"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "in"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  next_hop            = var.default_next_hop
  subnet_id           = module.subnet_inbound.id
  tags                = local.tags
}

module "subnet_outbound" {
  source               = "../subnet"
  location             = var.location
  environment          = var.environment
  workload             = "out"
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 1, 1)]
  delegation = {
    "Microsoft.Network.dnsResolvers" = {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

module "routing_outbound" {
  source              = "../pattern_routing"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "out"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  next_hop            = var.default_next_hop
  subnet_id           = module.subnet_outbound.id
  tags                = local.tags
}

module "private_dns_resolver" {
  source                      = "../private_dns_resolver"
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
  source                                     = "../private_dns_resolver_dns_forwarding_ruleset"
  location                                   = var.location
  environment                                = var.environment
  workload                                   = var.workload
  instance                                   = var.instance
  resource_group_name                        = module.resource_group.name
  private_dns_resolver_outbound_endpoint_ids = [module.private_dns_resolver.outbound_endpoint_id]
  virtual_network_id                         = module.virtual_network.id
  tags                                       = local.tags
}

module "private_dns_resolver_forwarding_rules" {
  source                    = "../private_dns_resolver_forwarding_rule"
  for_each                  = { for rule in var.dns_forwarding_rules : rule.domain_name => rule }
  dns_forwarding_ruleset_id = module.private_dns_resolver_dns_forwarding_ruleset.id
  domain_name               = each.value.domain_name
  target_dns_servers        = each.value.target_dns_servers
}

module "private_dns_zones" {
  source               = "../private_dns_zone"
  for_each             = toset(var.private_endpoint_zones)
  name                 = each.value
  resource_group_name  = module.resource_group.name
  virtual_network_link = true
  virtual_network_id   = module.virtual_network.id
  tags                 = local.tags
}