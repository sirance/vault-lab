provider "vault" {
  address = var.vault_url
  # auth_login_jwt {
  #   mount = "jwt"
  #   role  = "github-actions-role"
  # }
}
