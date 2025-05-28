resource "digitalocean_domain" "default" {
  name = "changeme.com"
}

resource "digitalocean_record" "example" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = digitalocean_droplet.example.name
  value  = digitalocean_droplet.example.ipv4_address
  ttl    = 300
}
