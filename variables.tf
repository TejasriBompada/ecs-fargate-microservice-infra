# -------------------------------
# VPC Variables
# -------------------------------
variable "env" {}
variable "region" {}
variable "vpc_cidr" {}
variable "azs" {
  type = list(string)
}
variable "public_subnet_newbits" {
  type = number
}
variable "private_subnet_newbits" {
  type = number
}
variable "enable_ha_nat" {
  type = bool
}
variable "tags" {
  type = map(string)
}

# -------------------------------
# Security Groups Variables
# -------------------------------
variable "allowed_bastion_cidr" {
  description = "CIDR range allowed to access bastion via SSH"
  type        = string
}

# -------------------------------
# ECS Variables
# -------------------------------
variable "app_name" {}
variable "container_image" {}
variable "container_port" {}
variable "cpu" { default = 256 }
variable "memory" { default = 512 }

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks for this environment"
}

variable "enable_autoscaling" { default = true }
variable "min_capacity" { default = 1 }
variable "max_capacity" { default = 3 }
variable "cpu_target_utilization" { default = 60 }

# -------------------------------
# Bastion Variables
# -------------------------------
variable "instance_type" {
  type    = string
  default = "t3a.nano"
}

# -------------------------------
# RDS Variables
# -------------------------------

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password (optional, only for overriding generated password)"
  type        = string
  sensitive   = true
  nullable    = true    # allow null
  default     = null
}

variable "multi_az" {
  type = bool
  default = false
}

variable "db_engine" {
  description = "The database engine (e.g., mysql, postgres, aurora-mysql)"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "The database engine version"
  type        = string
  default     = "15.3"
}

variable "db_instance_class" {
  description = "The RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The initial storage allocated (in GB)"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum autoscaling storage (in GB)"
  type        = number
  default     = 100
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection for prod"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot on delete"
  type        = bool
  default     = true
}
