# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat-gateway-eip" {
  depends_on = [
    aws_route_table_association.rt-association
  ]

  vpc = true
}