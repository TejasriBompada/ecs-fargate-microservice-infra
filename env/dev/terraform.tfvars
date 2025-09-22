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
container_image    = "hashicorp/http-echo:0.2.3"
container_port     = 5678
cpu                = 256
memory             = 512
desired_count      = 1
enable_autoscaling = false
min_capacity       = 1
max_capacity       = 3
cpu_target_utilization = 60

# -------------------------------
# RDS Module
# -------------------------------
db_username = "appadmin"
db_engine               = "postgres"
db_engine_version       = "15.3"
db_instance_class       = "db.t3.micro"
db_allocated_storage    = 20
db_max_allocated_storage = 100
multi_az                = false
rds_deletion_protection = false
rds_skip_final_snapshot = true
