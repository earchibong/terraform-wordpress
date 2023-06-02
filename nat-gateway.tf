# Create a NAT Gateway for MySQL instance to access the Internet (performing source NAT).
resource "aws_nat_gateway" "nat-gateway" {
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
    aws_eip.nat-gateway-eip
  ]

  # The Allocation ID of the Elastic IP address for the gateway
  allocation_id = aws_eip.nat-gateway-eip.id
  
  # The Subnet ID of the subnet in which the NAT gateway is placed
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "NAT Gateway Project"
  }
}