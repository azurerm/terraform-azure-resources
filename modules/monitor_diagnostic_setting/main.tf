terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

module "naming" {
  source = "../naming"
  suffix = [reverse(split("/", var.target_resource_id))[0]]
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = coalesce(var.custom_name, module.naming.monitor_diagnostic_setting.name)
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
