resource "aws_instance" "main" {
	ami = ami.id
	instance_type = "c7i-flex.large"
	vpc_security_group_ids = [aws_security_group.main.id]
	key_name = "ami2"
	user_data = templatefile("{path.path.module}/bootstrap.sh.tftpl",{
		partition_number = 4
		extend_size = 30
	})

  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    volume_type           = "gp3"

    tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name}-jump"
      } 
    )
  }
  
  connection {
	type = "ssh"
	port = 22
	host = self.associate_public_ip_address
	user = "ec2-user"
	private_key = file("/home/ubuntu/.ssh/ami2.pem")
  }
  provisioner "file" {
	source = "/home/ubuntu/.aws/credentials"
	destination =  "/home/ec2-user/.aws/credentials"
  }
    provisioner "file" {
	source = "/home/ubuntu/.aws/config"
	destination =  "/home/ec2-user/.aws/config"
  }

	tags = merge(local.common_tags,
	{
		Name = "${local.common_name}-jump"
	})
	
}

resource "aws_security_group" "main" {
  name = "${local.common_name}-jump"

  egress {
	from_port = 0
	to_port = 0
	cidr_blocks = ["0.0.0.0/0"]
	protocol = "-1"
  }

  ingress {
	from_port = 22
	to_port = 22
	protocol = "TCP"
	cidr_blocks = [""]
  }

  tags = merge(local.common_tags,
	{
		Name = "${local.common_name}-jump"
	})
}
