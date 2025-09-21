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
# Terraform Backend
# -------------------------------
terraform {
  backend "s3" {}
}
