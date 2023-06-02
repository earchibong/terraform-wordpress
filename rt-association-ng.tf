# Create a Route Table Association of the NAT Gateway route table with the Private Subnet
resource "aws_route_table_association" "rt-association-ng" {
  depends_on = [
    aws_route_table.nat-gateway-rt
  ]

  # Public Subnet ID
  subnet_id = aws_subnet.private-subnet.id

  #  Route Table ID
  route_table_id = aws_route_table.nat-gateway-rt.id
}