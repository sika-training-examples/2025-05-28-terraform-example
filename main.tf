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

data "digitalocean_ssh_key" "extra" {
  name = "extra"
}

locals {
  ssh_keys = [
    digitalocean_ssh_key.default.fingerprint,
    data.digitalocean_ssh_key.extra.fingerprint,
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
