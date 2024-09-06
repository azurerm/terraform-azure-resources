variable "workload" {
  description = "(Optional) The usage or application of the Virtual Network."
  type        = string
  default     = "dns"
}

variable "environment" {
  description = "(Optional) The environment of the Virtual Network."
  type        = string
  default     = "prd"
}

variable "location" {
  description = "(Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Virtual Network."
  type        = string
  default     = "001"
}

variable "address_space" {
  description = "(Required) The address space that is used the Virtual Network."
  type        = list(string)
}

variable "firewall" {
  description = "(Optional) Firewall in Hub?."
  type        = bool
  default     = false
}

variable "default_next_hop" {
  description = "(Optional) The default next hop of the Virtual Network."
  type        = string
  default     = ""
}

variable "private_endpoint_zones" {
  description = "(Optional) A list of private endpoint zones."
  type        = list(string)
  default = [
    "privatelink.blob.core.windows.net",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.monitor.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.vaultcore.azure.net",
    "privatelink.cognitiveservices.azure.com",
    "privatelink.openai.azure.com",
    "privatelink.azurewebsites.net",
    "privatelink.search.windows.net",
    # "privatelink.1.azurestaticapps.net",
    # "privatelink.2.azurestaticapps.net",
    # "privatelink.3.azurestaticapps.net",
    # "privatelink.4.azurestaticapps.net",
    # "privatelink.5.azurestaticapps.net",
    # "privatelink.adf.azure.com",
    # "privatelink.afs.azure.net",
    # "privatelink.analysis.windows.net",
    # "privatelink.api.azureml.ms",
    # "privatelink.azconfig.io",
    # "privatelink.azure-api.net",
    # "privatelink.azure-automation.net",
    # "privatelink.azurecr.io",
    # "privatelink.azuredatabricks.net",
    # "privatelink.azure-devices.net",
    # "privatelink.azure-devices-provisioning.net",
    # "privatelink.azurehdinsight.net",
    # "privatelink.azurestaticapps.net",
    # "privatelink.azuresynapse.net",
    # "privatelink.batch.azure.com",
    # "privatelink.cassandra.cosmos.azure.com",
    # "privatelink.database.windows.net",
    # "privatelink.datafactory.azure.net",
    # "privatelink.dev.azuresynapse.net",
    # "privatelink.dfs.core.windows.net",
    # "privatelink.dicom.azurehealthcareapis.com",
    # "privatelink.digitaltwins.azure.net",
    # "privatelink.directline.botframework.com",
    # "privatelink.documents.azure.com",
    # "privatelink.eventgrid.azure.net",
    # "privatelink.fhir.azurehealthcareapis.com",
    # "privatelink.file.core.windows.net",
    # "privatelink.gremlin.cosmos.azure.com",
    # "privatelink.guestconfiguration.azure.com",
    # "privatelink.his.arc.azure.com",
    # "privatelink.kubernetesconfiguration.azure.com",
    # "privatelink.managedhsm.azure.net",
    # "privatelink.mariadb.database.azure.com",
    # "privatelink.media.azure.net",
    # "privatelink.mongo.cosmos.azure.com",
    # "privatelink.mysql.database.azure.com",
    # "privatelink.notebooks.azure.net",
    # "privatelink.pbidedicated.windows.net",
    # "privatelink.postgres.database.azure.com",
    # "privatelink.prod.migration.windowsazure.com",
    # "privatelink.purview.azure.com",
    # "privatelink.purviewstudio.azure.com",
    # "privatelink.queue.core.windows.net",
    # "privatelink.redis.cache.windows.net",
    # "privatelink.service.signalr.net",
    # "privatelink.servicebus.windows.net",
    # "privatelink.siterecovery.windowsazure.com",
    # "privatelink.sql.azuresynapse.net",
    # "privatelink.table.core.windows.net",
    # "privatelink.table.core.windows.net",
    # "privatelink.table.cosmos.azure.com",
    # "privatelink.tip1.powerquery.microsoft.com",
    # "privatelink.token.botframework.com",
    # "privatelink.web.core.windows.net",
    # "privatelink.westeurope.kusto.windows.net",
    # "privatelink.workspace.azurehealthcareapis.com",
  ]
}

variable "module_tags" {
  description = "(Optional) Include the default tags?"
  type        = bool
  default     = true
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = null
}

variable "dns_forwarding_rules" {
  description = "(Optional) A list of DNS forwarding rules."
  type = list(object({
    domain_name = string
    target_dns_servers = list(object({
      ip_address = string
      port       = number
    }))
  }))
  default = []
}