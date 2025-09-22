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

# -------------------------------
# ECS Module
# -------------------------------
app_name           = "microservice"
container_image    = "public.ecr.aws/nginx/nginx:latest"
container_port     = 80
cpu                = 256
memory             = 512
desired_count      = 1
enable_autoscaling = false
min_capacity       = 1
max_capacity       = 3
cpu_target_utilization = 60
