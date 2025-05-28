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

resource "digitalocean_record" "alias" {
  count = 2

  domain = digitalocean_domain.default.id
  type   = "CNAME"
  name   = "${digitalocean_record.example.name}-alias-${count.index}"
  value  = "${digitalocean_record.example.fqdn}."
  ttl    = 300
}
