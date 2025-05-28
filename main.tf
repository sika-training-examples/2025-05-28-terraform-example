resource "digitalocean_ssh_key" "default" {
  name       = "default"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "digitalocean_ssh_key" "extra" {
  name = "extra"
}

resource "digitalocean_droplet" "example" {
  lifecycle {
    prevent_destroy = true
  }

  image  = "debian-12-x64"
  name   = "example"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    digitalocean_ssh_key.default.fingerprint,
    data.digitalocean_ssh_key.extra.fingerprint,
  ]
}

output "ip_addr" {
  value = digitalocean_droplet.example.ipv4_address
}

output "cost_per_day" {
  value = digitalocean_droplet.example.price_hourly * 24
}
