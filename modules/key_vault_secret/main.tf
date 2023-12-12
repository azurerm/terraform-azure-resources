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
      terraform-azurerm-module = "key_vault_secret"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )
}

resource "azurerm_key_vault_secret" "secret" {
  name         = var.name
  value        = var.value
  tags         = local.tags
  key_vault_id = var.key_vault_id
}