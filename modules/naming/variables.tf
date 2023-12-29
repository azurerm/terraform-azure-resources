variable "prefix" {
  description = "(Optional) Not recommended - Prefix to add to the name of you resources."
  type        = list(string)
  default     = []
}

variable "suffix" {
  description = "(Optional) Recommended - Suffix to add to the name of you resources. Please use only lowercase characters when possible."
  type        = list(string)
  default     = []
}

variable "unique-seed" {
  description = "(Optional) Custom value for the random characters to be used."
  type        = string
  default     = ""
}

variable "unique-length" {
  description = "(Optional) Max length of the uniqueness suffix to be added."
  type        = number
  default     = 0
}

variable "unique-include-numbers" {
  description = "(Optional) Include numbers in the unique generation."
  type        = bool
  default     = true
}
