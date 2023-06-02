# Create a Security Group for the WordPress instance, so that anyone in the outside world can access the instance by HTTP, PING, SSH
resource "aws_security_group" "wp-sg" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet
  ]

  # Name of the webserver security group
  name        = "webserver-sg"
  description = "Allow outside world to access the instance via HTTP, PING, SSH"

  # VPC ID in which Security group has to be created!
  vpc_id = aws_vpc.vpc.id

  # Create an inbound rule for webserver HTTP access
  ingress {
    description = "HTTP to Webserver"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Create an inbound rule for PING
  ingress {
    description = "PING to Webserver"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Create an inbound rule for SSH access
  ingress {
    description = "SSH to Webserver"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    ##security_groups = [aws_security_group.bastion-sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outward Network Traffic from the WordPress webserver
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Wordpress Security Group"
  }
}