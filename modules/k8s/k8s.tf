terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "name" {}
variable "kubernetes_version" {}
variable "node_size" {}
variable "node_count" {}

resource "digitalocean_kubernetes_cluster" "this" {
  name   = var.name
  region = "fra1"
  // doctl kubernetes options versions
  version = var.kubernetes_version

  node_pool {
    name = var.name
    // doctl kubernetes options sizes
    size       = var.node_size
    node_count = var.node_count
  }
}

resource "digitalocean_loadbalancer" "this" {
  name   = var.name
  region = "fra1"

  enable_proxy_protocol = false

  droplet_tag = "k8s:${digitalocean_kubernetes_cluster.this.id}"

  healthcheck {
    port     = 80
    protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 80
    target_port     = 80
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 443
    target_port     = 443
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }
}

output "name" {
  value = var.name
}

output "lb_ip" {
  value = digitalocean_loadbalancer.this.ip
}

output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.this.kube_config.0.raw_config
  sensitive = true
}
