# Create a Security Group for Mysql instance which allows database access to only those instances who are having the WordPress security group created previously
resource "aws_security_group" "mysql-sg" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet,
    aws_security_group.wp-sg
  ]

  # Name of the security group for MySQL instance
  name        = "mysql-sg"
  description = "MySQL Access only from the Webserver Instances"

  # VPC ID in which Security group will be created
  vpc_id = aws_vpc.vpc.id

  # Create an inbound rule for MySQL
  ingress {
    description     = "MySQL Access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wp-sg.id]
  }

  # Create an inbound rule for SSH access
  ingress {
    description = "SSH to Webserver"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }
  
  # Outbound Network Traffic from the MySQL instance
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySQL Security Group"
  }
}