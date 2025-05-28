terraform {
  backend "pg" {}
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    slu = {
      source  = "sikalabsx/slu"
      version = "0.2.0"
    }
  }
}

variable "digitalocean_token" {}

provider "digitalocean" {
  token = var.digitalocean_token
}

locals {
  // List of objects I really dont want to destroy
  PREVENT_DESTROY = [
    digitalocean_droplet.example, // PREVENT DESTROY
  ]
}
