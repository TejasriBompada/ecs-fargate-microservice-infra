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
