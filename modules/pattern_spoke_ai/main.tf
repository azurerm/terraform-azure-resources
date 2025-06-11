terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    restapi = {
      source = "mastercard/restapi"
    }
  }
}

locals {
  module_tags = tomap(
    {
      terraform-azurerm-composable-level2 = "pattern_spoke_ai"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )
}

data "azurerm_client_config" "current" {}

data "http" "ipinfo" {
  count = var.ip_filter ? 1 : 0
  url   = "https://ifconfig.me/ip"
  #data.http.ipinfo[0].response_body
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
  dns_servers         = var.dns_servers
  tags                = local.tags
}

module "subnet-pe" {
  source               = "../subnet"
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = "001"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 1, 0)]
}

module "subnet-app" {
  source               = "../subnet"
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = "002"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 1, 1)]
  delegation = {
    "Microsoft.Web/serverFarms" = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

module "routing-pe" {
  source              = "../pattern_routing"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = "001"
  resource_group_name = module.resource_group.name
  next_hop            = var.next_hop
  subnet_id           = module.subnet-pe.id
  tags                = local.tags
}

module "routing-app" {
  source              = "../pattern_routing"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = "002"
  resource_group_name = module.resource_group.name
  next_hop            = var.next_hop
  subnet_id           = module.subnet-app.id
  tags                = local.tags
}

module "ai_services" {
  source                = "../ai_services"
  location              = var.location
  environment           = var.environment
  workload              = var.workload
  instance              = var.instance
  resource_group_name   = module.resource_group.name
  public_network_access = var.private_paas ? "Disabled" : "Enabled"
  identity = [
    {
      type = "SystemAssigned"
    }
  ]
  network_acls = [
    {
      default_action = var.ip_filter ? "Deny" : "Allow"
      ip_rules       = var.ip_filter ? [data.http.ipinfo[0].response_body] : []
    }
  ]
  tags = local.tags
}

module "ai_services_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  target_resource_id         = module.ai_services.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

resource "azurerm_private_endpoint" "ai_services" {
  count                         = var.private_paas ? 1 : 0
  name                          = "${module.ai_services.name}-pe"
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  subnet_id                     = module.subnet-pe.id
  custom_network_interface_name = "${module.ai_services.name}-nic"

  private_service_connection {
    name                           = "psc-${module.ai_services.name}"
    private_connection_resource_id = module.ai_services.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-${module.ai_services.name}"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}

#########################################################################
resource "azurerm_cognitive_deployment" "this" {
  name                 = "deployment-gpt-4o"
  cognitive_account_id = module.ai_services.id
  model {
    format  = "OpenAI"
    name    = "gpt-4o"
    version = "2024-05-13"
  }
  sku {
    name     = "GlobalStandard"
    capacity = 256
  }
}

module "locations" {
  source   = "../locations"
  location = var.location
}

module "naming" {
  source = "../naming"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

resource "azurerm_service_plan" "this" {
  name                = module.naming.app_service_plan.name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  os_type             = "Linux"
  sku_name            = "B3"
}

resource "azurerm_linux_web_app" "this" {
  name                                           = "${module.ai_services.custom_subdomain_name}-webapp"
  location                                       = module.resource_group.location
  resource_group_name                            = module.resource_group.name
  service_plan_id                                = azurerm_service_plan.this.id
  virtual_network_subnet_id                      = module.subnet-app.id
  public_network_access_enabled                  = var.private_paas ? false : true
  webdeploy_publish_basic_authentication_enabled = false
  ftp_publish_basic_authentication_enabled       = false

  identity {
    type = "SystemAssigned"
  }

  site_config {
    app_command_line = "python3 -m gunicorn app:app"
    application_stack {
      python_version = "3.11"
    }
    ip_restriction_default_action = var.ip_filter ? "Deny" : "Allow"
    dynamic "ip_restriction" {
      for_each = var.ip_filter ? [1] : []
      content {
        ip_address = "${data.http.ipinfo[0].response_body}/32"
        action     = "Allow"
      }
    }
  }

  app_settings = {
    AUTH_ENABLED = "false"
    UI_TITLE     = "Demo AI Services"
    ##################################################################
    AZURE_OPENAI_EMBEDDING_NAME    = ""
    AZURE_OPENAI_ENDPOINT          = "https://${module.ai_services.custom_subdomain_name}.openai.azure.com/"
    AZURE_OPENAI_MAX_TOKENS        = "2048"
    AZURE_OPENAI_MODEL             = azurerm_cognitive_deployment.this.name
    AZURE_OPENAI_MODEL_NAME        = "gpt-4o"
    AZURE_OPENAI_RESOURCE          = ""
    AZURE_OPENAI_STOP_SEQUENCE     = ""
    AZURE_OPENAI_SYSTEM_MESSAGE    = "You are an AI assistant that helps people find information."
    AZURE_OPENAI_TEMPERATURE       = "0.7"
    AZURE_OPENAI_TOP_P             = "0.95"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    #AZURE_OPENAI_KEY              = module.ai_services.primary_access_key
    #################################################################
    DATASOURCE_TYPE      = "AzureCognitiveSearch"
    AZURE_SEARCH_INDEX   = "azureblob-index"
    AZURE_SEARCH_SERVICE = azurerm_search_service.this.name
    #AZURE_SEARCH_KEY                      = azurerm_search_service.this.primary_key
    # AZURE_SEARCH_CONTENT_COLUMNS         = ""
    # AZURE_SEARCH_ENABLE_IN_DOMAIN        = "false"
    # AZURE_SEARCH_FILENAME_COLUMN         = ""
    # AZURE_SEARCH_PERMITTED_GROUPS_COLUMN = ""
    # AZURE_SEARCH_QUERY_TYPE              = ""
    # AZURE_SEARCH_SEMANTIC_SEARCH_CONFIG  = ""
    # AZURE_SEARCH_STRICTNESS              = "3"
    # AZURE_SEARCH_TITLE_COLUMN            = ""
    # AZURE_SEARCH_TOP_K                   = "5"
    # AZURE_SEARCH_URL_COLUMN              = ""
    # AZURE_SEARCH_USE_SEMANTIC_SEARCH     = "false"
    # AZURE_SEARCH_VECTOR_COLUMNS          = ""
    # ELASTICSEARCH_CONTENT_COLUMNS        = ""
    # ELASTICSEARCH_EMBEDDING_MODEL_ID     = ""
    # ELASTICSEARCH_ENABLE_IN_DOMAIN       = "false"
    # ELASTICSEARCH_ENCODED_API_KEY        = ""
    # ELASTICSEARCH_ENDPOINT               = ""
    # ELASTICSEARCH_FILENAME_COLUMN        = ""
    # ELASTICSEARCH_INDEX                  = ""
    # ELASTICSEARCH_QUERY_TYPE             = ""
    # ELASTICSEARCH_STRICTNESS             = "3"
    # ELASTICSEARCH_TITLE_COLUMN           = ""
    # ELASTICSEARCH_TOP_K                  = "5"
    # ELASTICSEARCH_URL_COLUMN             = ""
    # ELASTICSEARCH_VECTOR_COLUMNS         = ""
  }
}

resource "azurerm_private_endpoint" "webapp" {
  count                         = var.private_paas ? 1 : 0
  name                          = "${azurerm_linux_web_app.this.name}-pe"
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  subnet_id                     = module.subnet-pe.id
  custom_network_interface_name = "${azurerm_linux_web_app.this.name}-nic"

  private_service_connection {
    name                           = "psc-${azurerm_linux_web_app.this.name}"
    private_connection_resource_id = azurerm_linux_web_app.this.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-${module.ai_services.name}"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}

resource "azurerm_app_service_source_control" "this" {
  app_id                 = azurerm_linux_web_app.this.id
  repo_url               = "https://github.com/microsoft/sample-app-aoai-chatGPT.git"
  branch                 = "main"
  use_manual_integration = true

  // It will generate some delay between the wenapp creation and the source control configuration
  # depends_on = [
  #   azurerm_private_endpoint.webapp
  # ]
}

module "storage_account" {
  source                        = "../storage_account"
  location                      = var.location
  environment                   = var.environment
  workload                      = var.workload
  resource_group_name           = module.resource_group.name
  public_network_access_enabled = var.private_paas ? false : true
  network_rules_default_action  = var.private_paas || var.ip_filter ? "Deny" : "Allow"
  network_rules_bypass          = ["AzureServices"]
  network_rules_ip_rules        = var.ip_filter ? [data.http.ipinfo[0].response_body] : []
  tags                          = local.tags
}

resource "azurerm_storage_container" "this" {
  name                  = "internal-data"
  storage_account_name  = module.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "this" {
  for_each = fileset(path.module, "file_uploads/*")

  name                   = trimprefix(each.key, "file_uploads/")
  storage_account_name   = module.storage_account.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  source                 = "${path.module}/${each.key}"
}

resource "azurerm_private_endpoint" "storage_account" {
  count                         = var.private_paas ? 1 : 0
  name                          = "${module.storage_account.name}-pe"
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  subnet_id                     = module.subnet-pe.id
  custom_network_interface_name = "${module.storage_account.name}-nic"

  private_service_connection {
    name                           = "psc-${module.storage_account.name}"
    private_connection_resource_id = module.storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-${module.storage_account.name}"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}

resource "azurerm_search_service" "this" {
  name                          = module.naming.search_service.name
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  sku                           = "basic"
  local_authentication_enabled  = true
  authentication_failure_mode   = "http401WithBearerChallenge"
  public_network_access_enabled = var.private_paas ? false : true
  allowed_ips                   = var.ip_filter ? [data.http.ipinfo[0].response_body] : []
  identity {
    type = "SystemAssigned"
  }
}

module "search_service_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  target_resource_id         = azurerm_search_service.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

# azapi provider will be needed to create the search service
# resource "azapi_resource" "search_services" {
#   type = "Microsoft.Search/searchServices@2024-03-01-preview"
#   name = module.naming.search_service.name
#   location = module.resource_group.location
#   parent_id = module.resource_group.id
#   tags = local.tags
#   identity {
#     type = "SystemAssigned"
#   }
#   body = jsonencode({
#     properties = {
#       authOptions = {
#         aadOrApiKey = {
#           aadAuthFailureMode = "http401WithBearerChallenge"
#         }
#       }
#       disableLocalAuth = false
#       networkRuleSet = {
#         bypass = "AzureServices"
#         ipRules = var.ip_filter ? [
#           {
#             "value": data.http.ipinfo[0].response_body
#           }
#         ] : []
#       }
#       partitionCount = 1
#       publicNetworkAccess = var.private_paas ? "Disabled" : "Enabled"
#       replicaCount = 1
#     }
#     sku = {
#       name = "basic"
#     }
#   })
# }

resource "azurerm_private_endpoint" "search_service" {
  count                         = var.private_paas ? 1 : 0
  name                          = "${azurerm_search_service.this.name}-pe"
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  subnet_id                     = module.subnet-pe.id
  custom_network_interface_name = "${azurerm_search_service.this.name}-nic"

  private_service_connection {
    name                           = "psc-${azurerm_search_service.this.name}"
    private_connection_resource_id = azurerm_search_service.this.id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-${azurerm_search_service.this.name}"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}

resource "azurerm_search_shared_private_link_service" "search_service_storage_spls" {
  count              = (var.private_paas || var.ip_filter) ? 1 : 0
  name               = "${azurerm_search_service.this.name}-${module.storage_account.name}-spls"
  search_service_id  = azurerm_search_service.this.id
  subresource_name   = "blob"
  target_resource_id = module.storage_account.id
  request_message    = "Share Private Link Service created by Terraform for Storage Account."
}

resource "azurerm_role_assignment" "cognitive_services_openai_contributor" {
  scope                = module.resource_group.id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = azurerm_search_service.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = module.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_search_service.this.identity[0].principal_id
}

resource "azurerm_role_assignment" "search_index_data_reader" {
  scope                = module.resource_group.id
  role_definition_name = "Search Index Data Reader"
  principal_id         = module.ai_services.identity[0].principal_id
}

resource "azurerm_role_assignment" "search_service_contributor" {
  scope                = module.resource_group.id
  role_definition_name = "Search Service Contributor"
  principal_id         = module.ai_services.identity[0].principal_id
}

resource "azurerm_role_assignment" "cognitive_services_openai_user" {
  scope                = module.resource_group.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_linux_web_app.this.identity[0].principal_id
}
