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

# -------------------------------
# Security Groups Module
# -------------------------------
allowed_bastion_cidr = "REDACTED/32"  # VPN CIDR for prod

# -------------------------------
# ECS Module
# -------------------------------
app_name           = "microservice"
container_image    = "hashicorp/http-echo:0.2.3"
container_port     = 5678
cpu                = 256
memory             = 512
desired_count      = 3
enable_autoscaling = true
min_capacity       = 2
max_capacity       = 6
cpu_target_utilization = 60
