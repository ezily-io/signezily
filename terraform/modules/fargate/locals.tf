locals {
  name = "${var.application}-${var.service_name}-${var.environment}"

  awslogs_group = coalesce(
    var.awslogs_group,
    "/ecs/${var.environment}/${var.application}/${var.service_name}"
  )

  # TODO: add better default timeout/interval
  default_health_check = var.network_lb ? {
    enabled  = true
    port     = "traffic-port"
    protocol = "TCP"
    } : {
    enabled  = true
    path     = "/"
    port     = "traffic-port"
    protocol = "HTTP"
  }

  ports = flatten([
    for name, container in var.containers : [
      for port, config in container.ports :
      {
        container = name
        internal  = port
        host      = lookup(config, "host", port)
        lb        = lookup(config, "lb", port)

        secure   = lookup(config, "secure", false)
        protocol = lookup(config, "protocol", "tcp")
        redirect = lookup(config, "redirect", false)

        health_check = merge(
          local.default_health_check,
          lookup(config, "health_check", {})
        )
      }
    ]
  ])
}