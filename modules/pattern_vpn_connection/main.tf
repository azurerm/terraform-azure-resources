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
      terraform-azurerm-composable-level1 = "pattern_vpn_connection"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )
}

data "azurerm_virtual_network_gateway" "gateway_1" {
  name                = split("/", var.gateway_1_id)[8]
  resource_group_name = split("/", var.gateway_1_id)[4]
}

data "azurerm_public_ip" "pip_gateway_1" {
  name                = split("/", data.azurerm_virtual_network_gateway.gateway_1.ip_configuration[0].public_ip_address_id)[8]
  resource_group_name = split("/", data.azurerm_virtual_network_gateway.gateway_1.ip_configuration[0].public_ip_address_id)[4]
}

data "azurerm_virtual_network_gateway" "gateway_2" {
  name                = split("/", var.gateway_2_id)[8]
  resource_group_name = split("/", var.gateway_2_id)[4]
}

data "azurerm_public_ip" "pip_gateway_2" {
  name                = split("/", data.azurerm_virtual_network_gateway.gateway_2.ip_configuration[0].public_ip_address_id)[8]
  resource_group_name = split("/", data.azurerm_virtual_network_gateway.gateway_2.ip_configuration[0].public_ip_address_id)[4]
}

resource "random_password" "this" {
  length           = 32
  special          = true
  override_special = "_%@"
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
}

module "gateway_1" {
  source              = "../local_network_gateway"
  location            = var.location
  resource_group_name = data.azurerm_virtual_network_gateway.gateway_2.resource_group_name
  custom_name         = "${data.azurerm_virtual_network_gateway.gateway_1.name}-lng"
  gateway_address     = data.azurerm_public_ip.pip_gateway_1.ip_address
  asn                 = data.azurerm_virtual_network_gateway.gateway_1.bgp_settings[0].asn
  bgp_peering_address = split(",", data.azurerm_virtual_network_gateway.gateway_1.bgp_settings[0].peering_address)[0]
  tags                = local.tags
}

module "gateway_2" {
  source              = "../local_network_gateway"
  location            = var.location
  resource_group_name = data.azurerm_virtual_network_gateway.gateway_1.resource_group_name
  custom_name         = "${data.azurerm_virtual_network_gateway.gateway_2.name}-lng"
  gateway_address     = data.azurerm_public_ip.pip_gateway_2.ip_address
  asn                 = data.azurerm_virtual_network_gateway.gateway_2.bgp_settings[0].asn
  bgp_peering_address = split(",", data.azurerm_virtual_network_gateway.gateway_2.bgp_settings[0].peering_address)[0]
  tags                = local.tags
}

module "connection_1_to_2" {
  source                     = "../virtual_network_gateway_connection"
  location                   = var.location
  resource_group_name        = data.azurerm_virtual_network_gateway.gateway_1.resource_group_name
  custom_name                = "${data.azurerm_virtual_network_gateway.gateway_2.name}-vnc"
  virtual_network_gateway_id = var.gateway_1_id
  local_network_gateway_id   = module.gateway_2.id
  shared_key                 = random_password.this.result
  enable_bgp                 = true
  tags                       = local.tags
}

module "connection_2_to_1" {
  source                     = "../virtual_network_gateway_connection"
  location                   = var.location
  resource_group_name        = data.azurerm_virtual_network_gateway.gateway_2.resource_group_name
  custom_name                = "${data.azurerm_virtual_network_gateway.gateway_1.name}-vnc"
  virtual_network_gateway_id = var.gateway_2_id
  local_network_gateway_id   = module.gateway_1.id
  shared_key                 = random_password.this.result
  enable_bgp                 = true
  tags                       = local.tags
}

module "key_vault_secret" {
  source = "../key_vault_secret"
  count  = var.vault_psk ? 1 : 0
  name   = "vpn-psk-${data.azurerm_virtual_network_gateway.gateway_1.name}-${data.azurerm_virtual_network_gateway.gateway_2.name}"
  value  = random_password.this.result
  tags = {
    gateway_1_id = var.gateway_1_id
    gateway_2_id = var.gateway_2_id
  }
  key_vault_id = var.key_vault_id
}