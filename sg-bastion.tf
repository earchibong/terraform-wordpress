# Creating a Security Group for the Bastion Host which allows anyone in the outside world to access the Bastion Host by SSH.
resource "aws_security_group" "bastion-sg" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet
  ]

  # Name of the security group for Bastion Host
  name        = "bastion-sg"
  description = "MySQL Access only from the Webserver Instances!"

  # VPC ID in which Security group will be created
  vpc_id = aws_vpc.vpc.id

  # Create an inbound rule for Bastion Host SSH
  ingress {
    description = "Bastion Host SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Network Traffic from the Bastion Host
  egress {
    description = "Outbound from Bastion Host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-security-group"
  }
}