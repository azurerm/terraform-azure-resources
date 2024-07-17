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
      terraform-azurerm-composable-level1 = "pattern_standalone_site"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )
  access_policy_object_ids = concat([data.azurerm_client_config.current.object_id], var.additional_access_policy_object_ids)
}

data "azurerm_client_config" "current" {}

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
  dns_servers         = var.dns_servers
  tags                = local.tags
}

module "subnet_gateway" {
  source               = "../subnet"
  count                = var.gateway ? 1 : 0
  location             = var.location
  custom_name          = "GatewaySubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 0)]
}

module "public_ip_gateway" {
  source              = "../public_ip"
  count               = var.gateway ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
}

module "gateway" {
  source              = "../virtual_network_gateway"
  count               = var.gateway ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  asn                 = var.asn
  ip_configurations = [{
    public_ip_address_id = module.public_ip_gateway[0].id,
    subnet_id            = module.subnet_gateway[0].id
    }
  ]
}

module "subnet_firewall" {
  source               = "../subnet"
  count                = var.firewall ? 1 : 0
  location             = var.location
  custom_name          = "AzureFirewallSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 1)]
}

module "public_ip_firewall" {
  source              = "../public_ip"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
}

module "firewall" {
  source               = "../firewall"
  count                = var.firewall ? 1 : 0
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  public_ip_address_id = module.public_ip_firewall[0].id
  subnet_id            = module.subnet_firewall[0].id
}

module "subnet_workload" {
  source               = "../subnet"
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 2)]
}

module "linux_virtual_machine" {
  source              = "../linux_virtual_machine"
  count               = var.linux_virtual_machine ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet_workload.id
  size                = var.virtual_machine_size
  tags                = local.tags
}

module "key_vault" {
  source              = "../key_vault"
  count               = var.linux_virtual_machine ? 1 : 0
  tenant_id           = data.azurerm_client_config.current.tenant_id
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  access_policy = [for id in local.access_policy_object_ids : {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = id
    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
    key_permissions = []
    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "Purge"
    ]
    storage_permissions = []
  }]
  network_acls = [
    {
      bypass                     = "AzureServices"
      default_action             = "Allow"
      ip_rules                   = []
      virtual_network_subnet_ids = []
    }
  ]
  tags = local.tags
}

module "key_vault_secret" {
  source = "../key_vault_secret"
  count  = var.linux_virtual_machine ? 1 : 0
  name   = module.linux_virtual_machine[0].name
  value  = module.linux_virtual_machine[0].admin_password
  tags = {
    username = module.linux_virtual_machine[0].admin_username
    image    = module.linux_virtual_machine[0].source_image_reference_offer
    ip       = module.linux_virtual_machine[0].private_ip_address
  }
  key_vault_id = module.key_vault[0].id
}

module "bastion" {
  source              = "../bastion_host"
  count               = var.linux_virtual_machine ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  sku                 = "Developer"
  virtual_network_id  = module.virtual_network.id
  tags                = local.tags
}