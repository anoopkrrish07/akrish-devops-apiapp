#-----------------------------------------------------------------------------------------------------------
# Global variables
#-----------------------------------------------------------------------------------------------------------

variable "env" {
  type    = string
  default = "dev"
}

variable "group" {
  type    = string
  default = "devops"
}

variable "app" {
  type    = string
  default = "app"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

#-----------------------------------------------------------------------------------------------------------
# VPC Vars
#-----------------------------------------------------------------------------------------------------------

variable "azs" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "private_subnets" {
  type    = list(any)
  default = ""
}

variable "public_subnets" {
  type    = list(any)
  default = ""
}

variable "database_subnets" {
  type    = list(any)
  default = ""
}

variable "vpc_enable_nat_gateway" {
  default = true
}

variable "vpc_single_nat_gateway" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}
