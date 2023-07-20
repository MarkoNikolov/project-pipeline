variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "aws_vpc_id" {
  description = "AWS VPC id"
  default     = "vpc-00bda4c936615e5bc"
}

variable "aws_ecr_repository_name" {
  description = "AWS ECR repository name"
  default     = "flaskapp"
}

variable "aws_network_subnet_id" {
  description = "AWS Network subnet id"
  default     = "subnet-00492a4620aad1579"
}

variable "aws_instance_type" {
  description = "AWS instance type"
  default     = "t2.medium"
}