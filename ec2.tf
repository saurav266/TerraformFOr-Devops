resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "my_security_group" {

  name        = "automate-sg"
  description = "Terraform generated security group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    description = "Allow all outbound traffic"
  }
}

resource "aws_instance" "my_instance" {
  //count=2 // how many instance create
  // if you want to laounch insance but in diffrent size use for_each
  for_each=tomap({
    "Tws-junnon"= "t3.micro"
    "sk_two"= "t3.medium"
  })

  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]
  ami           = "ami-006f82a1d5a27da54"
  instance_type = each.value

  key_name = aws_key_pair.my_key.key_name
  user_data = file("install_nginx.sh")
  

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}