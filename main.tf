# -------------------------------
# Provider
# -------------------------------
provider "aws" {
  region = var.region
}


# -------------------------------
# Terraform Backend
# -------------------------------
terraform {
  backend "s3" {}
}