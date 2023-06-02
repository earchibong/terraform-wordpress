# Launch a Bastion Host
resource "aws_instance" "bastion" {
  depends_on = [
    aws_instance.wordpress,
    aws_instance.mysql
  ]

  # AMI ID - Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public-subnet.id

  key_name = var.keypair

  # Attach Bastion Security Group
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]

  tags = {
    Name = "bastion"
  }
}