resource "aws_instance" "main" {
	ami = ami.id
	instance_type = "c7i-flex.large"
	vpc_security_group_ids = [aws_security_group.main.id]

	tags = merge(local.common_tags,
	{
		Name = "${local.common_name}-jump"
	})
	
}

resource "aws_security_group" "main" {
  name = "${local.common_name}-jump"

  tags = merge(local.common_tags,
	{
		Name = "${local.common_name}-jump"
	})
}
