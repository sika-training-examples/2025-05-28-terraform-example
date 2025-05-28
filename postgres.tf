resource "digitalocean_database_cluster" "db" {
  lifecycle {
    prevent_destroy = true
  }

  name       = "example"
  engine     = "pg"
  version    = "17"
  size       = "db-s-1vcpu-1gb"
  region     = "fra1"
  node_count = 1
}

output "db_conn" {
  value     = digitalocean_database_cluster.db.uri
  sensitive = true
}
