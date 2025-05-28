module "iceland_app" {
  source = "./modules/do_app"

  name                = "iceland"
  image_registry_type = "GHCR"
  image_registry      = "ghcr.io"
  image_repository    = "ondrejsika/iceland-5"
}

output "iceland_app_url" {
  value = module.iceland_app.live_url
}
