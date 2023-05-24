resource "vault_password_policy" "default-password" {
  name = "default"

  policy = <<EOT
  length=20

rule "charset" {
  charset = "abcdefghijklmnopqrstuvwxyz"
  min-chars = 2
}

rule "charset" {
  charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  min-chars = 2
}

rule "charset" {
  charset = "0123456789"
  min-chars = 2
}

rule "charset" {
  charset = "!@#$%^&*"
  min-chars = 2
}
EOT
}

resource "vault_password_policy" "plain-password" {
  name = "plain"

  policy = <<EOT
  length=20

rule "charset" {
  charset = "abcdefghijklmnopqrstuvwxyz"
  min-chars = 2
}

rule "charset" {
  charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  min-chars = 2
}

rule "charset" {
  charset = "0123456789"
  min-chars = 2
}
EOT
}
