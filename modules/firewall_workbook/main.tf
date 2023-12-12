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
      terraform-azurerm-module = "firewall_workbook"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.workload != "" ? { workload = var.workload } : {},
    var.environment != "" ? { environment = var.environment } : {},
    var.tags
  )
}

data "http" "firewall_workbook" {
  url = var.url
}

resource "random_uuid" "this" {
}

resource "azurerm_application_insights_workbook" "this" {
  name                = random_uuid.this.result
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = var.display_name
  data_json           = data.http.firewall_workbook.response_body
  tags                = local.tags
}