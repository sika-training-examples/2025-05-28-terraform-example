locals {
  DEBIAN = "debian-12-x64"
  UBUNTU = "ubuntu-24-04-x64"
  FRA    = "fra1"
}

locals {
  region = local.FRA
}

resource "digitalocean_ssh_key" "default" {
  name       = "default"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_ssh_key" "ondrejsika_mac" {
  name       = "ondrejsika-mac"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslNKgLyoOrGDerz9pA4a4Mc+EquVzX52AkJZz+ecFCYZ4XQjcg2BK1P9xYfWzzl33fHow6pV/C6QC3Fgjw7txUeH7iQ5FjRVIlxiltfYJH4RvvtXcjqjk8uVDhEcw7bINVKVIS856Qn9jPwnHIhJtRJe9emE7YsJRmNSOtggYk/MaV2Ayx+9mcYnA/9SBy45FPHjMlxntoOkKqBThWE7Tjym44UNf44G8fd+kmNYzGw9T5IKpH1E1wMR+32QJBobX6d7k39jJe8lgHdsUYMbeJOFPKgbWlnx9VbkZh+seMSjhroTgniHjUl8wBFgw0YnhJ/90MgJJL4BToxu9PVnH"
}

data "digitalocean_ssh_key" "extra" {
  name = "extra"
}

locals {
  ssh_keys = [
    digitalocean_ssh_key.default.fingerprint,
    data.digitalocean_ssh_key.extra.fingerprint,
    digitalocean_ssh_key.ondrejsika_mac.fingerprint,
  ]
}

resource "digitalocean_droplet" "example" {
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ssh_keys]
  }

  image    = local.DEBIAN
  name     = "example"
  region   = local.region
  size     = "s-1vcpu-1gb"
  ssh_keys = local.ssh_keys
}

output "ip_addr" {
  value = digitalocean_droplet.example.ipv4_address
}

output "cost_per_day" {
  value = format("$%.2f", digitalocean_droplet.example.price_hourly * 24)
}
