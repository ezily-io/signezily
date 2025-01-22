resource "aws_ecs_task_definition" "documenso" {
  family                   = "${var.application}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = module.documenso_execution_role.role
  task_role_arn            = module.documenso_execution_role.role
  container_definitions = jsonencode([
    {
      name  = "app",
      image = var.image,
      portMappings = [
        { hostPort = var.port, protocol = "tcp", containerPort = var.port }
      ],
      secrets     = local.common_secrets,
      environment = local.common_env
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = local.log_group,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "${var.application}"
        }
      },
    },
    {
      name  = "marketing",
      image = var.marketing_image,
      portMappings = [
        { hostPort = 3001, protocol = "tcp", containerPort = 3001 },
      ],
      secrets     = local.common_secrets,
      environment = local.marketing_env
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = local.log_group,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "${var.application}"
        }
      },
    },
    {
      name  = "documentation",
      image = var.docs_image,
      portMappings = [
        { hostPort = 3002, protocol = "tcp", containerPort = 3002 },
      ],
      secrets     = local.common_secrets,
      environment = local.docs_env
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = local.log_group,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "${var.application}"
        }
      },
    },
  ])
}


    # {
    #   name  = "marketing",
    #   image = var.marketing_image,
    #   portMappings = [
    #     { hostPort = 3001, protocol = "tcp", containerPort = 3001 },
    #   ],
    #   secrets     = local.common_secrets,
    #   environment = local.common_env
    #   logConfiguration = {
    #     logDriver = "awslogs",
    #     options = {
    #       awslogs-group         = local.log_group,
    #       awslogs-region        = var.region,
    #       awslogs-stream-prefix = "${var.application}"
    #     }
    #   },
    # }
    # {
    #   name  = "documentation",
    #   image = var.docs_image,
    #   portMappings = [
    #     { hostPort = 3002, protocol = "tcp", containerPort = 3002 },
    #   ],
    #   secrets     = local.common_secrets,
    #   environment = local.common_env
    #   logConfiguration = {
    #     logDriver = "awslogs",
    #     options = {
    #       awslogs-group         = local.log_group,
    #       awslogs-region        = var.region,
    #       awslogs-stream-prefix = "${var.application}"
    #     }
    #   },
    # },




# resource "aws_ecs_task_definition" "cubestore_cluster" {
#   count                    = var.cubestore_cluster ? 1 : 0
#   family                   = "cubestore-${var.environment}"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = var.cpu
#   memory                   = var.memory
#   execution_role_arn       = module.cube_execution_role.role
#   task_role_arn            = module.cube_task_role.role
#   container_definitions = jsonencode(concat([
#     {
#       name  = "app"
#       image = var.cubestore_image,
#       portMappings = [
#         { hostPort = local.meta_port, protocol = "tcp", containerPort = local.meta_port },
#         { hostPost = 3306, protocol = "tcp", containerPort = 3306 },
#         { hostPost = 3030, protocol = "tcp", containerPort = 3030 },
#       ],
#       environment = concat([
#         {
#           name  = "CUBESTORE_SERVER_NAME",
#           value = local.router_server_name
#         },
#         {
#           name  = "CUBESTORE_META_PORT",
#           value = tostring(local.meta_port)
#         },
#         {
#           name  = "CUBESTORE_WORKERS",
#           value = join(",", local.worker_server_names),
#         }
#       ], local.common_env)
#       logConfiguration = {
#         logDriver = "awslogs",
#         options = {
#           awslogs-group         = local.SERVER_LOG_GROUP,
#           awslogs-region        = var.region,
#           awslogs-stream-prefix = "app"
#         }
#       },
#     }
#     ],
#     [
#       for idx, worker in local.workers : {
#         name  = "worker${idx}"
#         image = var.cubestore_image,
#         portMappings = [
#           { hostPort = worker.port, protocol = "tcp", containerPort = worker.port }
#         ],
#         environment = concat([
#           {
#             name  = "CUBESTORE_SERVER_NAME",
#             value = "${worker.host}:${worker.port}"
#           },
#           {
#             name  = "CUBESTORE_WORKER_PORT",
#             value = tostring(worker.port)
#           },
#           {
#             name  = "CUBESTORE_META_ADDR",
#             value = local.router_server_name
#           },
#           {
#             name  = "CUBESTORE_WORKERS",
#             value = join(",", local.worker_server_names),
#           }
#         ], local.common_env)

#         logConfiguration = {
#           logDriver = "awslogs",
#           options = {
#             awslogs-group         = local.SERVER_LOG_GROUP,
#             awslogs-region        = var.region,
#             awslogs-stream-prefix = "worker${idx}"
#           }
#         },
#         dependsOn = [
#           {
#             containerName = "app",
#             condition     = "START"
#           }
#         ]
#       }
#   ]))
# }
