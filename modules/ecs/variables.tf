variable "env" {
  type        = string
  description = "Environment name (dev, prod)"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "app_name" {
  type        = string
  description = "Application name"
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks for this environment"
}

variable "container_image" {
  type        = string
  description = "ECR image URI"
}

variable "container_name" {
  type        = string
  description = "Container name"
}

variable "container_port" {
  type        = number
  default     = 80
}

variable "cpu" {
  type        = number
  default     = 256
}

variable "memory" {
  type        = number
  default     = 512
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group IDs to attach to the service ENIs (usually private ALB SG or app SG)."
  default     = []
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign public IP to task ENI (avoid true in prod; true useful for quick dev debugging)."
  default     = false
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable Application Auto Scaling (scale by CPU)."
  default     = true
}

variable "cpu_target_utilization" {
  type        = number
  description = "Target CPU utilization (%) for autoscaling policy."
  default     = 60
}

variable "min_capacity" {
  type        = number
  description = "Min task count for autoscaling (prod should be >= 2)."
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Max task count for autoscaling."
  default     = 6
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}

variable "alb_target_group_arn" {
  description = "Target Group ARN to register ECS service with ALB"
  type        = string
  default     = ""  # optional, allows ECS without ALB
}
