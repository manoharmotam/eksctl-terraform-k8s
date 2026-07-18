variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "key_name" {
  default = "ami2"
}

variable "instance_type" {
  default = "c7i-flex.large"
}

variable "aws_key_id" {
  type = string
  sensitive = true
}

variable "aws_secret_key" {
  type = string
  sensitive = true
}

variable "ssh_password" {
  sensitive = true
}