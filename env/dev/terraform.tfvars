# -------------------------------
# General / environment
# -------------------------------
env    = "dev"
region = "us-east-1"
tags = {
  env     = "dev"
  project = "ecs-microservice"
}

# -------------------------------
# VPC Module
# -------------------------------
vpc_cidr               = "10.0.0.0/20"
azs                    = ["us-east-1a","us-east-1b"]
public_subnet_newbits  = 8
private_subnet_newbits = 8
enable_ha_nat          = false

# -------------------------------
# Security Groups Module
# -------------------------------
allowed_bastion_cidr   = "REDACTED/32"  # using local IP

container_port     = 80

