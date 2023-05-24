resource "vault_mount" "secret" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV2 Secrets Engine"
}

resource "vault_kv_secret_backend_v2" "secrets" {
  mount = vault_mount.secret.path
}

