# -------------------------------
# Provider
# -------------------------------
provider "aws" {
  region = var.region
}

# -------------------------------
# VPC Module
# -------------------------------
module "vpc" {
  source                 = "./modules/vpc"
  name                   = var.env
  region                 = var.region
  vpc_cidr               = var.vpc_cidr
  azs                    = var.azs
  public_subnet_newbits  = var.public_subnet_newbits
  private_subnet_newbits = var.private_subnet_newbits
  enable_ha_nat          = var.enable_ha_nat
  tags                   = var.tags
}

# -------------------------------
# Security Groups Module
# -------------------------------
module "security_groups" {
  source               = "./modules/security_groups"
  env                  = var.env
  vpc_id               = module.vpc.vpc_id
  container_port       = var.container_port
  allowed_bastion_cidr = var.allowed_bastion_cidr
  tags                 = var.tags
}

# -------------------------------
# VPCE Module
# -------------------------------

module "vpce" {
  source                  = "./modules/vpce"
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids
  vpce_sg_id              = module.security_groups.vpce_sg_id
  region                  = var.region
  tags                    = var.tags
  name                    = var.env
}

# -------------------------------
# ALB Module
# -------------------------------
module "alb" {
  source                     = "./modules/alb"
  name                       = var.env
  container_port             = var.container_port
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  alb_sg_id                  = module.security_groups.public_sg_id
  acm_cert_arn               = "" # leave blank for dev
  enable_deletion_protection = false
}

# -------------------------------
# ECR Module 
# -------------------------------
module "microservice_ecr" {
  source               = "./modules/ecr"
  name                 = "microservice-${var.env}"
  lifecycle_max_images = 5
  tags                 = var.tags
}

# -------------------------------
# ECS Module
# -------------------------------
module "ecs" {
  source             = "./modules/ecs"
  env                = var.env
  app_name           = var.app_name
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.private_sg_id]

  container_image = var.container_image
  container_name  = "${var.app_name}-${var.env}"
  container_port  = var.container_port
  cpu             = var.cpu
  memory          = var.memory

  desired_count          = var.desired_count
  enable_autoscaling     = var.enable_autoscaling
  min_capacity           = var.min_capacity
  max_capacity           = var.max_capacity
  cpu_target_utilization = var.cpu_target_utilization
  alb_target_group_arn   = module.alb.target_group_arn

  depends_on = [module.alb]
}

# -------------------------------
# Bastion Module 
# -------------------------------

module "bastion" {
  source        = "./modules/bastion"
  name          = "${var.env}-bastion"
  env           = var.env
  subnet_id     = module.vpc.private_subnet_ids[0]
  bastion_sg_id = module.security_groups.bastion_sg_id
  instance_type = var.instance_type
  tags          = var.tags
}

# -------------------------------
# RDS Module 
# -------------------------------

module "rds" {
  source             = "./modules/rds"
  name               = var.env
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id

  # Credentials & settings
  db_username           = var.db_username
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  deletion_protection   = var.rds_deletion_protection
  skip_final_snapshot   = var.rds_skip_final_snapshot
  multi_az              = var.multi_az

  tags = var.tags
}

# -------------------------------
# Terraform Backend
# -------------------------------
terraform {
  backend "s3" {}
}
