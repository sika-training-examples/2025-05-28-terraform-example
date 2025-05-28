terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "name" {}
variable "image_registry_type" {}
variable "image_registry" {}
variable "image_repository" {}
variable "image_tag" {
  default = "latest"
}
variable "instance_count" {
  default = 1
}
variable "port" {
  default = 80
}

resource "digitalocean_app" "this" {
  spec {
    name   = var.name
    region = "fra"

    service {
      name           = var.name
      instance_count = var.instance_count
      http_port      = var.port
      image {
        registry_type = var.image_registry_type
        registry      = var.image_registry
        repository    = var.image_repository
        tag           = var.image_tag
      }
    }

    ingress {
      rule {
        component {
          name = var.name
        }
        match {
          path {
            prefix = "/"
          }
        }
      }
    }
  }
}

output "live_domain" {
  value = digitalocean_app.this.live_domain
}

output "live_url" {
  value = digitalocean_app.this.live_url
}
