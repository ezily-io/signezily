docker_image_tag    = "1.8.1"
application         = "signezily"
environment         = "prod"
service_name        = "app"
cpu                 = "4096"
memory              = "8192"
node_options_memory = "7372"
dynamic_capacity_provider_strategy = [
  { capacity_provider = "FARGATE_SPOT", weight = 99, base = 0 },
  { capacity_provider = "FARGATE", weight = 1, base = 0 }
]