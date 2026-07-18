locals {
  ami_id = data.aws_ami.ami_id.id
  common_name = "${var.project}-${var.environment}"
  common_tags = {
    Name        = local.common_name
    Project     = var.project
    Environment = var.environment
  }
}