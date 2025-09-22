resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*"
  keepers = {
    rds_instance = var.name  # only regenerates if this changes
  }
}

resource "aws_secretsmanager_secret" "rds" {
  name        = "rds-${var.name}-credentials"
  description = "Master credentials for ${var.name} RDS"
  tags        = merge(var.tags, { Name = "${var.name}-rds-secret" })
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}
