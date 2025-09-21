variable "name" {
  description = "Name prefix for VPC resources"
  type        = string
}

variable "region" {}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones to spread subnets across"
  type        = list(string)
}

variable "public_subnet_newbits" {
  description = "Number of additional bits for public subnets (defines size)"
  type        = number
  default     = 4
}

variable "private_subnet_newbits" {
  description = "Number of additional bits for private subnets (defines size)"
  type        = number
  default     = 4
}

variable "enable_ha_nat" {
  description = "Deploy one NAT per AZ (true) or single NAT (false)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
