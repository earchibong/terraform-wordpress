# Define the public and private subnets, specifying the VPC ID, CIDR block range, and availability zone.
resource "aws_subnet" "private-subnet" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet
  ]

  # VPC in which subnet will be created
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_range

  # The AZ for the subnet
  availability_zone = var.az_private

  tags = {
    Name = "Private Subnet"
  }
}