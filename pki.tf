resource "vault_mount" "root_ca_v1" {
  path                      = "ca/v1"
  type                      = "pki"
  description               = "PKI engine CA Cert Engine"
  default_lease_ttl_seconds = local.default_5y_in_sec
  max_lease_ttl_seconds     = local.default_10y_in_sec
}

resource "vault_pki_secret_backend_root_cert" "root_ca_v1" {
  depends_on           = [vault_mount.root_ca_v1]
  backend              = vault_mount.root_ca_v1.path
  type                 = "internal"
  common_name          = "Root CA 2023"
  ttl                  = local.default_10y_in_sec
  exclude_cn_from_sans = true
  key_type             = "rsa"
  key_bits             = "4096"
  ou                   = var.domain
  organization         = var.organization
  country              = var.country
  locality             = var.locality
  province             = var.province
}


resource "vault_mount" "pki_intermediate" {
  path                  = "pki"
  type                  = "pki"
  description           = "PKI engine with intermediate key for ${var.domain}"
  max_lease_ttl_seconds = local.default_5y_in_sec
}

resource "vault_pki_secret_backend_intermediate_cert_request" "pki_intermediate" {
  depends_on   = [vault_mount.pki_intermediate]
  backend      = vault_mount.pki_intermediate.path
  type         = "internal"
  common_name  = "Intermediate 2023"
  key_type     = "rsa"
  key_bits     = "4096"
  ou           = var.domain
  organization = var.organization
  country      = var.country
  locality     = var.locality
  province     = var.province
}

resource "vault_pki_secret_backend_root_sign_intermediate" "pki_intermediate" {
  depends_on           = [vault_pki_secret_backend_intermediate_cert_request.pki_intermediate, vault_pki_secret_backend_root_cert.root_ca_v1]
  backend              = vault_mount.root_ca_v1.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.pki_intermediate.csr
  common_name          = "Intermediate 2023"
  exclude_cn_from_sans = true
  ou                   = var.domain
  organization         = var.organization
  country              = var.country
  locality             = var.locality
  province             = var.province
  max_path_length      = 1
  ttl                  = local.default_3y_in_sec
}

resource "vault_pki_secret_backend_intermediate_set_signed" "pki_intermediate" {
  depends_on  = [vault_pki_secret_backend_root_sign_intermediate.pki_intermediate]
  backend     = vault_mount.pki_intermediate.path
  certificate = format("%s\n%s", vault_pki_secret_backend_root_sign_intermediate.pki_intermediate.certificate, vault_pki_secret_backend_root_cert.root_ca_v1.certificate)
}

resource "vault_pki_secret_backend_role" "intermediate" {
  backend            = vault_mount.pki_intermediate.path
  name               = local.domain
  ttl                = local.default_1wk_in_sec
  allow_ip_sans      = true
  key_type           = "rsa"
  key_bits           = 4096
  key_usage          = ["DigitalSignature"]
  allow_any_name     = false
  allow_localhost    = false
  allowed_domains    = ["${var.domain}"]
  allow_bare_domains = false
  allow_subdomains   = true
  server_flag        = true
  client_flag        = true
  no_store           = true
  country            = ["${var.country}"]
  locality           = ["${var.locality}"]
  province           = ["${var.province}"]
}

resource "vault_policy" "pki" {
  name = "pki"

  policy = <<EOT
path "${vault_mount.pki_intermediate.path}*" {
  capabilities = ["read", "list"]
}
path "${vault_mount.pki_intermediate.path}/roles/${vault_pki_secret_backend_role.intermediate.name}" {
  capabilities = ["create", "update"]
}
path "${vault_mount.pki_intermediate.path}/sign/${vault_pki_secret_backend_role.intermediate.name}" {
  capabilities = ["create", "update"]
}
path "${vault_mount.pki_intermediate.path}/issue/${vault_pki_secret_backend_role.intermediate.name}" {
  capabilities = ["create", "update"]
}

EOT
}
