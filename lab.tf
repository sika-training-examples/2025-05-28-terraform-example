locals {
  labs = {
    "foo" = merge(local.droplet_defaults, {
      image = local.UBUNTU
    })
    "bar" = merge(local.droplet_defaults, {
      size = "s-2vcpu-2gb"
    })
    "baz" = merge(local.droplet_defaults, {})
  }

  droplet_defaults = {
    image    = local.DEBIAN
    region   = local.region
    size     = "s-1vcpu-1gb"
    ssh_keys = local.ssh_keys
  }
}

resource "digitalocean_droplet" "lab" {
  lifecycle {
    ignore_changes = [ssh_keys]
  }

  for_each = local.labs

  image    = each.value.image
  name     = each.key
  region   = each.value.region
  size     = each.value.size
  ssh_keys = each.value.ssh_keys
  tags     = ["terraform"]
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

