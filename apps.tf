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

module "hello_world_app" {
  source = "./modules/do_app"

  for_each = {
    en = {
      text = "Hello World!"
    }
    cz = {
      text = "Ahoj Svete!"
    }
  }

  name                = each.key
  image_registry_type = "GHCR"
  image_registry      = "ghcr.io"
  image_repository    = "sikalabs/hello-world-server"
  instance_count      = 2
  port                = 8000
}

output "hello_world_app_urls" {
  value = {
    for key, val in module.hello_world_app :
    key => val.live_url
  }
}
