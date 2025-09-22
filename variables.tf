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
variable "container_port" { default = 80 }
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
