# Associate the routing table to the Public Subnet to provide the Internet Gateway address.
resource "aws_route_table_association" "rt-association" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet,
    aws_route_table.public-subnet-rt
  ]

  # Public Subnet ID
  subnet_id = aws_subnet.public-subnet.id

  #  Route Table ID
  route_table_id = aws_route_table.public-subnet-rt.id
}