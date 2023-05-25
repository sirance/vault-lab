terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.15.2"
    }
  }

}

locals {
  default_10y_in_sec = 315360000
  default_5y_in_sec  = 157680000
  default_3y_in_sec  = 94608000
  default_1y_in_sec  = 31536000
  default_1wk_in_sec = 604800
  default_1hr_in_sec = 3600
  domain             = replace("${var.domain}", ".", "-")
}

