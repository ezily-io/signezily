docker_image_tag    = "latest"
application         = "signezily"
environment         = "dev"
service_name        = "app"
cpu                 = "2048"
memory              = "4096"
node_options_memory = "4096"
dynamic_capacity_provider_strategy = [
  { capacity_provider = "FARGATE_SPOT", weight = 99, base = 1 },
  { capacity_provider = "FARGATE", weight = 1, base = 0 }
]