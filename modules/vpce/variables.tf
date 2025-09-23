variable "vpc_id" {
  description = "VPC ID where endpoints will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for interface endpoints"
  type        = list(string)
}

variable "vpce_sg_id" {
  description = "Security group ID for interface endpoints (ECR, etc.)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Tags for VPCE resources"
  type        = map(string)
}

variable "name" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "private_route_table_ids" {
  description = "List of private route table IDs for S3 Gateway endpoint"
  type        = list(string)
}
