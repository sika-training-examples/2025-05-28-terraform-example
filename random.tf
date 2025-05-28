resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_"
}

output "password" {
  value = nonsensitive(random_password.password.result)
}

resource "slu_random_password" "password" {}

output "password_slu" {
  value = nonsensitive(slu_random_password.password.result)
}
