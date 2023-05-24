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
