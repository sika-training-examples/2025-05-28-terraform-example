module "example_k8s" {
  source = "./modules/k8s"

  name               = "example"
  kubernetes_version = "1.32.2-do.1"
  node_count         = 1
  node_size          = "s-2vcpu-4gb"
}

resource "digitalocean_record" "k8s_example" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = module.example_k8s.name
  value  = module.example_k8s.lb_ip
  ttl    = 300
}

resource "digitalocean_record" "k8s_example_wildcard" {
  domain = digitalocean_domain.default.id
  type   = "CNAME"
  name   = "*.${digitalocean_record.k8s_example.name}"
  value  = "${digitalocean_record.k8s_example.fqdn}."
  ttl    = 300
}

output "kubeconfig_example" {
  value     = module.example_k8s.kubeconfig
  sensitive = true
}

