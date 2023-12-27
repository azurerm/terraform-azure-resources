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
      terraform-azurerm-module = "firewall_policy"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.workload != "" ? { workload = var.workload } : {},
    var.environment != "" ? { environment = var.environment } : {},
    var.tags
  )
}

module "locations" {
  source   = "../locations"
  location = var.location
}

module "naming" {
  source = "../naming"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

resource "azurerm_web_application_firewall_policy" "this" {
  name                = coalesce(var.custom_name, module.naming.application_gateway_firewall_policy.name)
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    enabled                     = var.policy_settings_enabled
    mode                        = var.policy_settings_mode
    request_body_check          = var.policy_settings_request_body_check
    file_upload_limit_in_mb     = var.policy_settings_file_upload_limit_in_mb
    max_request_body_size_in_kb = var.policy_settings_max_request_body_size_in_kb
  }

  managed_rules {
    managed_rule_set {
      type    = var.managed_rule_set_type
      version = var.managed_rule_set_version
    }
    dynamic "exclusion" {
      for_each = var.exclusion_configuration

      content {
        match_variable          = exclusion.value.match_variable
        selector                = exclusion.value.selector
        selector_match_operator = exclusion.value.selector_match_operator
        dynamic "excluded_rule_set" {
          for_each = exclusion.value.excluded_rule_set_configuration
          iterator = rule_set

          content {
            type    = rule_set.value.type
            version = rule_set.value.version
            dynamic "rule_group" {
              for_each = rule_set.value.rule_group_configuration

              content {
                rule_group_name = rule_group.value.rule_group_name
                excluded_rules  = rule_group.value.excluded_rules
              }
            }
          }
        }
      }
    }
  }

  dynamic "custom_rules" {
    for_each = var.custom_rules_configuration

    content {
      name      = custom_rules.value.name
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type
      action    = custom_rules.value.action
      dynamic "match_conditions" {
        for_each = custom_rules.value.match_conditions_configuration

        content {
          dynamic "match_variables" {
            for_each = match_conditions.value.match_variable_configuration

            content {
              variable_name = match_variables.value.match_variable
              selector      = match_variables.value.selector
            }
          }
          match_values       = match_conditions.value.match_values
          operator           = match_conditions.value.operator
          negation_condition = match_conditions.value.negation_condition
          transforms         = match_conditions.value.transforms
        }
      }
    }
  }

  tags = var.tags
}
