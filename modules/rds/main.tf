resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, { Name = "${var.name}-rds-subnet-group" })
}

resource "aws_db_instance" "this" {
  identifier            = "${var.name}-rds"
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = true
  deletion_protection   = var.deletion_protection

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]
  publicly_accessible    = false
  multi_az               = var.multi_az

  username            = var.db_username
  password            = var.db_password != null ? var.db_password : random_password.db_password.result
  skip_final_snapshot = var.skip_final_snapshot

  tags = merge(var.tags, { Name = "${var.name}-rds" })
}
