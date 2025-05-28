resource "digitalocean_droplet" "provisioner" {
  image    = local.DEBIAN
  name     = "provisioner"
  region   = local.region
  size     = "s-1vcpu-1gb"
  ssh_keys = local.ssh_keys

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y nginx",
    ]
  }

  provisioner "file" {
    content     = "<h1>Hello from Terraform provisioner</h1>"
    destination = "/var/www/html/index.html"
  }
}

output "see" {
  value = "http://${digitalocean_droplet.provisioner.ipv4_address}"
}
