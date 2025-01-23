locals {
  vpc_name             = "${var.vpc_id} ${upper(data.aws_region.current.name)}"
  intranet_cidr_blocks = var.vpc_cidr

  groups = {
    SSH = {
      ports  = [22]
    }

    Redash = {
      ports  = [5000]
    }

    Airbyte = {
      ports  = [8000]
    }

    Postgres = {
      ports  = [5432]
    }

    HTTP = {
      public = true
      ports  = [80, 443]
    }

    redis = {
      ports = [6379]
    }
  }
}

locals {
    inbound_intersection = tolist(setintersection([for x,y in local.groups : x], var.inbound))
    outbound_intersection = tolist(setintersection([for x,y in local.groups : x], var.outbound))
    public_inbound_intersection = tolist(setintersection([for x,y in local.groups : x], var.public_inbound))
    public_outbound_intersection = tolist(setintersection([for x,y in local.groups : x], var.public_outbound))
}

locals {
  group_ports = flatten([
    for name, def in local.groups : [
      for port in def.ports : {
        key    = "${name}-${port}"
        port   = port
        public = lookup(def, "public", false)
        name   = name
      }
    ]
  ])
}