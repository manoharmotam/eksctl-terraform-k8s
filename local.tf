locals {
  common_name = "${var.project}-${var.environment}"
  common_tags = {
    Name = local.common_name
    Project = var.project
    Environment = var.environment
  }
}