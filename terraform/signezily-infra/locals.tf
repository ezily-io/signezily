locals {
  log_group = "/ecs/${var.environment}/${var.application}/${var.service_name}"

  secret_names = [
    "NEXTAUTH_URL",
    "NEXTAUTH_SECRET",
    "NEXT_PUBLIC_WEBAPP_URL",
    "NEXT_PUBLIC_MARKETING_URL",
    "NEXT_PRIVATE_DATABASE_URL",
    "NEXT_PRIVATE_DIRECT_DATABASE_URL",
    "NEXT_PRIVATE_ENCRYPTION_KEY",
    "NEXT_PRIVATE_ENCRYPTION_SECONDARY_KEY",
    "NEXT_PRIVATE_SMTP_TRANSPORT",
    "NEXT_PRIVATE_SMTP_HOST",
    "NEXT_PRIVATE_SMTP_PORT",
    "NEXT_PRIVATE_SMTP_USERNAME",
    "NEXT_PRIVATE_SMTP_PASSWORD",
    "NEXT_PRIVATE_SMTP_SECURE",
    "NEXT_PRIVATE_SMTP_FROM_NAME",
    "NEXT_PRIVATE_SMTP_FROM_ADDRESS",
    "NEXT_PRIVATE_SIGNING_LOCAL_FILE_CONTENTS",
    # "NEXT_PRIVATE_SIGNING_PASSPHRASE",
    "SIGN_CERT_FILE",
    "SIGN_PRIV_KEY_FILE",
    "SIGN_PRIV_KEY_PASS",
    "SIGN_CERT_NAME"
  ]

  additional_env = [
    for key, value in var.env : {
      name  = key,
      value = tostring(value)
    }
  ]

  additional_secrets = [
    for key, value in var.secrets : {
      name      = key,
      valueFrom = tostring(value)
    }
  ]

  common_env = concat([
    # {
    # name  = "NEXT_PRIVATE_SIGNING_LOCAL_FILE_PATH",
    # value = "/app/apps/sign_ezily_cert.p12"
    # value = "/opt/documenso/cert.p12"
    # },
    ],
    local.additional_env,
  )
  marketing_env = concat([
    {
      name  = "PORT",
      value = "3001"
    },
    ],
    local.common_env,
  )
  docs_env = concat([
    {
      name  = "PORT",
      value = "3002"
    },
    ],
    local.common_env,
  )

  common_secrets = concat([
    for name in local.secret_names : {
      name      = name,
      valueFrom = "${aws_secretsmanager_secret.documenso.id}:${name}::"
    }
    ],
    local.additional_secrets,
  )
}

