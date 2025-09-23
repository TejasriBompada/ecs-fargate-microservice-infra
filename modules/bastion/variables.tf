variable "env" {}

variable "name" {
  type    = string
  default = "bastion"
}

variable "ami_id" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t3a.nano"
}

variable "subnet_id" {
  type        = string
  description = "Private subnet ID for SSM-only bastion."
}

variable "bastion_sg_id" {
  type        = string
  description = "Security Group ID for bastion (SSM-only)."
}

variable "tags" {
  type    = map(string)
  default = {}
}
