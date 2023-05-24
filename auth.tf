resource "vault_auth_backend" "userpass" {
  type        = "userpass"
  description = "UserPass auth"
  tune {
    default_lease_ttl = "43200s"
    max_lease_ttl     = "604800s"
  }
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

