variable "name" {
  description = "Name prefix for ALB resources"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID for the ALB"
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "acm_cert_arn" {
  type    = string
  default = ""
}

variable "container_port" {
  type    = number
  default = 80
}
