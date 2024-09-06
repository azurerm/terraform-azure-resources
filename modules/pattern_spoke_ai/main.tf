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
  url = "https://ifconfig.me"
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

# resource "azurerm_ai_services" "this" {
#   name                = "account"
#   location            = "France Central"
#   resource_group_name = module.resource_group.name
#   sku_name            = "S0"
# }

# resource "azurerm_cognitive_deployment" "this" {
#   name                 = "deployment"
#   cognitive_account_id = azurerm_ai_services.this.id
#   model {
#     format  = "OpenAI"
#     name    = "gpt-4o"
#     version = "2024-05-13"
#   }
#   sku {
#     name = "GlobalStandard"
#   }
# }

module "ai_services" {
  source              = "../ai_services"
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  identity = [
    {
      type = "SystemAssigned"
    }
  ]
  tags = local.tags
}

resource "azurerm_private_endpoint" "ai_services" {
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
  public_network_access_enabled                  = false
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
  }
  app_settings = {
    AUTH_ENABLED = "false"
    UI_TITLE     = "Demo AI Services"
    ##################################################################
    AZURE_OPENAI_EMBEDDING_NAME = ""
    AZURE_OPENAI_ENDPOINT       = "https://${module.ai_services.custom_subdomain_name}.openai.azure.com/"
    #AZURE_OPENAI_KEY               = module.ai_services.primary_access_key
    AZURE_OPENAI_MAX_TOKENS        = "2048"
    AZURE_OPENAI_MODEL             = azurerm_cognitive_deployment.this.name
    AZURE_OPENAI_MODEL_NAME        = "gpt-4o"
    AZURE_OPENAI_RESOURCE          = ""
    AZURE_OPENAI_STOP_SEQUENCE     = ""
    AZURE_OPENAI_SYSTEM_MESSAGE    = "You are an AI assistant that helps people find information."
    AZURE_OPENAI_TEMPERATURE       = "0.7"
    AZURE_OPENAI_TOP_P             = "0.95"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    #################################################################
    DATASOURCE_TYPE    = "AzureCognitiveSearch"
    AZURE_SEARCH_INDEX = "azureblob-index"
    #AZURE_SEARCH_KEY     = azurerm_search_service.this.primary_key
    AZURE_SEARCH_SERVICE = azurerm_search_service.this.name
    # AZURE_SEARCH_CONTENT_COLUMNS                 = ""
    # AZURE_SEARCH_ENABLE_IN_DOMAIN                = "false"
    # AZURE_SEARCH_FILENAME_COLUMN                 = ""
    # AZURE_SEARCH_PERMITTED_GROUPS_COLUMN         = ""
    # AZURE_SEARCH_QUERY_TYPE                      = ""
    # AZURE_SEARCH_SEMANTIC_SEARCH_CONFIG          = ""
    # AZURE_SEARCH_STRICTNESS                      = "3"
    # AZURE_SEARCH_TITLE_COLUMN                    = ""
    # AZURE_SEARCH_TOP_K                           = "5"
    # AZURE_SEARCH_URL_COLUMN                      = ""
    # AZURE_SEARCH_USE_SEMANTIC_SEARCH             = "false"
    # AZURE_SEARCH_VECTOR_COLUMNS                  = ""
    # ELASTICSEARCH_CONTENT_COLUMNS                = ""
    # ELASTICSEARCH_EMBEDDING_MODEL_ID             = ""
    # ELASTICSEARCH_ENABLE_IN_DOMAIN               = "false"
    # ELASTICSEARCH_ENCODED_API_KEY                = ""
    # ELASTICSEARCH_ENDPOINT                       = ""
    # ELASTICSEARCH_FILENAME_COLUMN                = ""
    # ELASTICSEARCH_INDEX                          = ""
    # ELASTICSEARCH_QUERY_TYPE                     = ""
    # ELASTICSEARCH_STRICTNESS                     = "3"
    # ELASTICSEARCH_TITLE_COLUMN                   = ""
    # ELASTICSEARCH_TOP_K                          = "5"
    # ELASTICSEARCH_URL_COLUMN                     = ""
    # ELASTICSEARCH_VECTOR_COLUMNS                 = ""
  }
}

resource "azurerm_private_endpoint" "webapp" {
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
  depends_on = [
    azurerm_private_endpoint.webapp
  ]
}

module "storage_account" {
  source                       = "../storage_account"
  location                     = var.location
  environment                  = var.environment
  workload                     = var.workload
  resource_group_name          = module.resource_group.name
  network_rules_default_action = "Deny"
  network_rules_bypass         = ["AzureServices"]
  network_rules_ip_rules       = [data.http.ipinfo.response_body]
  tags                         = local.tags
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
  name                = module.naming.search_service.name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  sku                 = "basic"
  #sku                           = "standard"
  local_authentication_enabled  = true
  authentication_failure_mode   = "http401WithBearerChallenge"
  public_network_access_enabled = true
  allowed_ips = [
    data.http.ipinfo.response_body
  ]
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "search_service" {
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
  name               = "${azurerm_search_service.this.name}-${module.storage_account.name}-spls"
  search_service_id  = azurerm_search_service.this.id
  subresource_name   = "blob"
  target_resource_id = module.storage_account.id
  request_message    = "Share Private Link Service created by Terraform for Storage Account."
}

resource "azurerm_search_shared_private_link_service" "search_service_ai_services_spls" {
  name               = "${azurerm_search_service.this.name}-${module.ai_services.name}-spls"
  search_service_id  = azurerm_search_service.this.id
  subresource_name   = "cognitiveservices_account"
  target_resource_id = module.ai_services.id
  request_message    = "Share Private Link Service created by Terraform for Azure Cognitive Search."
  //Issue on subresource_name : Terraform expects the subresource cognitiveservices_account but Azure use account
  lifecycle {
    ignore_changes = [
      subresource_name
    ]
  }
}

# provider "restapi" {
#   uri                  = "https://${azurerm_search_service.this.name}.search.windows.net"
#   write_returns_object = true
#   debug                = true

#   headers = {
#     "api-key"      = azurerm_search_service.this.primary_key,
#     "Content-Type" = "application/json"
#   }

#   create_method  = "POST"
#   update_method  = "PUT"
#   destroy_method = "DELETE"
# }

# resource "restapi_object" "create_index" {
#   path         = "/indexes"
#   query_string = "api-version=2024-05-01-preview"
#   data         = templatefile("${path.module}/config/index.json", { search_service_name = azurerm_search_service.this.name })
#   id_attribute = "name" # The ID field on the response
# }

# resource "restapi_object" "create_datasource" {
#   path         = "/datasources"
#   query_string = "api-version=2024-05-01-preview"
#   data         = templatefile("${path.module}/config/data-source.json", { search_service_name = azurerm_search_service.this.name, storage_account_id = module.storage_account.id, container_name = azurerm_storage_container.this.name })
#   id_attribute = "name" # The ID field on the response
# }

# resource "restapi_object" "create_indexer" {
#   path         = "/indexers"
#   query_string = "api-version=2024-05-01-preview"
#   data         = templatefile("${path.module}/config/indexer.json", { search_service_name = azurerm_search_service.this.name })
#   id_attribute = "name" # The ID field on the response
#   depends_on = [ 
#     restapi_object.create_index,
#     restapi_object.create_datasource,
#     azurerm_role_assignment.storage_blob_data_contributor
#    ]
# }

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

