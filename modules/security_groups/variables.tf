variable "env" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the SGs will be created"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply"
  type        = map(string)
  default     = {}
}

variable "allowed_bastion_cidr" {
  description = "CIDR range allowed to SSH into bastion host"
  type        = string
}

variable "container_port" {}
