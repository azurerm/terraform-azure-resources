variable "custom_name" {
  type        = string
  description = "The name of the DNS forwarding rule."
  default     = ""
}

variable "dns_forwarding_ruleset_id" {
  type        = string
  description = "The ID of the DNS forwarding ruleset in which to create the DNS forwarding rule."
}

variable "domain_name" {
  type        = string
  description = "The domain name of the DNS forwarding rule."
}

variable "enabled" {
  type        = bool
  description = "Is the DNS forwarding rule enabled?"
  default     = true
}

variable "target_dns_servers" {
  type = list(object({
    ip_address = string
    port       = number
  }))
  description = "The target DNS servers of the DNS forwarding rule."
}
