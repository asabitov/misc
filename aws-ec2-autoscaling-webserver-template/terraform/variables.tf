variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

variable "ami" {}

variable "key_name" {}

variable "vpc_id" {}

variable "public_subnet_a_id" {}
variable "public_subnet_b_id" {}

variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "bastion_ips" {
    type = "list"
}

variable "whitelist_ips" {
    type = "list"
}

variable "ssl_certificate_arn" {}

