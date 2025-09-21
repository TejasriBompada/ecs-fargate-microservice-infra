# -------------------------------
# General / environment
# -------------------------------
env    = "prod"
region = "us-east-1"
tags = {
  env     = "prod"
  project = "ecs-microservice"
}

# -------------------------------
# VPC Module
# -------------------------------
vpc_cidr               = "10.1.0.0/16"
azs                    = ["us-east-1a","us-east-1b","us-east-1c"]
public_subnet_newbits  = 4
private_subnet_newbits = 4
enable_ha_nat          = true
