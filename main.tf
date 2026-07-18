resource "aws_instance" "jump" {
  ami                    = ami-01edba92f9036f76e
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.key_name
  user_data = templatefile("{path.path.module}/bootstrap.sh.tftpl", {
    partition_number = 4
    extend_size      = 30
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
    type        = "ssh"
    port        = 22
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("/home/ubuntu/.ssh/ami2.pem")
  }
  provisioner "file" {
    source      = "/home/ubuntu/.aws/credentials"
    destination = "/home/ec2-user/.aws/credentials"
  }
  provisioner "file" {
    source      = "/home/ubuntu/.aws/config"
    destination = "/home/ec2-user/.aws/config"
  }

  tags = merge(local.common_tags,
    {
      Name = "${local.common_name}-jump"
  })

}

resource "aws_security_group" "main" {
  name = "${local.common_name}-jump"

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${chomp(data.http.get_ip.response_body)}/32"]
  }

  tags = merge(local.common_tags,
    {
      Name = "${local.common_name}-jump"
  })
}

resource "terraform_data" "destroy_cluster" {
  input = {
    host = aws_instance.jump.public_ip
  }
}