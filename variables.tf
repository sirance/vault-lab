variable "domain" {
  default     = ""
  description = "The domain name required for PKI & secrets"
}

variable "organization" {
  default     = ""
  description = "Org name for PKI"
}

variable "country" {
  default     = ""
  description = "Country code for PKI"
}

variable "locality" {
  default     = ""
  description = "Locality for PKI"
}

variable "province" {
  default     = ""
  description = "Provine for PKI"
}

variable "vault_url" {
  default     = ""
  description = "URL for vault"
}

variable "vault_token" {
  default     = ""
  description = "token for vault"
}
