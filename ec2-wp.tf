# Launch a Webserver Instance hosting WordPress in it.
resource "aws_instance" "wordpress" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet,
    aws_security_group.bastion-sg,
    aws_security_group.mysql-sg
  ]

  # AMI ID - Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public-subnet.id

  key_name = "tf-deploy"

  # Security groups to use
  vpc_security_group_ids = [aws_security_group.wp-sg.id]

  tags = {
    Name = "wordpress"
  }
}