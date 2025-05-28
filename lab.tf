locals {
  labs = {
    "foo" = {}
    "bar" = {}
  }
}

resource "digitalocean_droplet" "lab" {
  for_each = local.labs

  image    = local.DEBIAN
  name     = each.key
  region   = local.region
  size     = "s-1vcpu-1gb"
  ssh_keys = local.ssh_keys
}

resource "digitalocean_record" "lab" {
  for_each = local.labs

  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "lab-${each.key}"
  value  = digitalocean_droplet.lab[each.key].ipv4_address
  ttl    = 300
}

output "labs" {
  value = {
    for key, val in local.labs :
    key => digitalocean_record.lab[key].fqdn
  }
}

