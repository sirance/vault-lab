provider "vault" {
  # address         = var.vault_url
  # token           = var.vault_token
  skip_tls_verify = true
  auth_login_jwt {
    mount = "jwt"
    role  = "github-actions-role"
  }
}
