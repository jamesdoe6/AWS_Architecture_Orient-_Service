variable "region" {
  type = string
  default = "eu-west-3"
}

variable "project" {
  type = string
}

variable "author" {
  type = string
}

variable "environment" {
  type = string
  description = "dev|staging|prod"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be one of: dev, staging, prod."
  }
}

variable "instance_type" {
  type = string
  validation {
    condition     = can(regex("^t2.micro$", var.instance_type))
    error_message = "The instance_type variable must be a t2.micro"
  }
}

variable "instance_ami" {
  type = string
  validation {
    condition     = "ami-0e207c18bb303cc68" == var.instance_ami
    error_message = "The instance_ami variable must be a valid ami-0e207c18bb303cc68."
  }
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cidr" {
  type = string
  validation {
    condition     = can(regex("^172\\.31\\.0\\.0/16$", var.cidr))
    error_message = "The cidr variable must be a valid CIDR block in the format 172.31.0.0/16."
  }
}

variable "igw" {
  type = string
}

variable "sg" {
  type = string
}

variable "environment" {
  type = string
  description = "dev|staging|prod"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be one of: dev, staging, prod."
  }
}

variable "security_group_ids" {
  type = list(string)
  description = "List of security group IDs to associate with the instance."
}

variable "vpc_security_group_ids" {
  type = list(string)
  description = "List of VPC security group IDs to associate with the instance."
}
