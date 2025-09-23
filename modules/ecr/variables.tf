variable "name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}

variable "lifecycle_max_images" {
  description = "Maximum number of images to keep in the repository"
  type        = number
  default     = 5
}
