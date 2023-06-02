# Define a route table for the public subnet, specifying the internet gateway as the target for all internet-bound traffic.
resource "aws_route_table" "public-subnet-rt" {
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]

  # VPC ID
  vpc_id = aws_vpc.vpc.id

  # NAT Rule
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route-table-internet-gateway"
  }
}