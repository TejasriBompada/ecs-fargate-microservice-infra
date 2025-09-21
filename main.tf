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
  public_subnet_newbits   = var.public_subnet_newbits
  private_subnet_newbits  = var.private_subnet_newbits
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
  container_port  = var.container_port
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
  source = "./modules/ecr"
  name                = "microservice-${var.env}"
  lifecycle_max_images = 5
  tags                = var.tags
}

# -------------------------------
# Terraform Backend
# -------------------------------
terraform {
  backend "s3" {}
}
