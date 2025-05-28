resource "digitalocean_droplet" "cloud_init" {
  image     = local.DEBIAN
  name      = "cloud-init"
  region    = local.region
  size      = "s-1vcpu-1gb"
  ssh_keys  = local.ssh_keys
  user_data = <<EOF
#cloud-config
write_files:
- path: /html/index.html
  permissions: "0755"
  owner: root:root
  content: |
    <h1>Hello from Cloud Init
runcmd:
  - |
    apt update
    apt install -y curl nginx
    cp /html/index.html /var/www/html/index.html
EOF
}

output "see_cloud_init" {
  value = "http://${digitalocean_droplet.cloud_init.ipv4_address}"
}
