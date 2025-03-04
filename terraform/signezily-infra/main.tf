module "documenso_database" {
  source      = "../modules/rds"
  del_protect = var.del_protect
  environment = var.environment
  application = var.application
  subnet_name = data.aws_db_subnet_group.rds.name
  security_groups = [
    data.aws_security_groups.postgres.ids[0]
  ]
}

module "signezily_execution_role" {
  source      = "../modules/iam"
  application = var.application
  environment = var.environment
  type        = "Execution"
  json_policy = file("${path.module}/iam_role/execution_policy.json")
}

module "signezily" {
  source                  = "../modules/fargate"
  vpc_id                  = data.aws_vpc.prod.id
  service_name            = var.service_name
  application             = var.application
  application_fullname    = var.application
  cluster_id              = var.cluster_id
  ecs_subnet_ids          = data.aws_subnets.prod_private.ids
  lb_subnet_ids           = data.aws_subnets.prod_public.ids
  certificate_arn         = var.certificate_arn
  ecs_execution_role_arn  = module.signezily_execution_role.role
  ecs_task_definition_arn = aws_ecs_task_definition.signezily.arn
  environment             = var.environment
  lb_internal             = false
  cpu                     = var.cpu
  memory                  = var.memory
  desired_count           = var.desired_count
  awslogs_group           = "/ecs/${var.environment}/${var.application}/${var.service_name}"
  containers = {
    app = {
      ports = {
        3000 = {
          lb       = 443
          secure   = true
          redirect = true
          health_check = {
            port = var.port
            path = "/api/health"
          }
        }
      }
    }
  }
}