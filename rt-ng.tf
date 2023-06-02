# Define a route table for the public subnet, specifying the internet gateway as the target for all internet-bound traffic.
resource "aws_route_table" "nat-gateway-rt" {
  depends_on = [
    aws_nat_gateway.nat-gateway
  ]

  # VPC ID
  vpc_id = aws_vpc.vpc.id

  # NAT Rule
  route {
    cidr_block = "0.0.0.0/0"

    # Identifier of a VPC NAT gateway
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = "route-table-nat-gateway"
  }
}