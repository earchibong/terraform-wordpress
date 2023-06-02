# Define the public and private subnets, specifying the VPC ID, CIDR block range, and availability zone.
resource "aws_subnet" "public-subnet" {
  depends_on = [
    aws_vpc.vpc
  ]

  # VPC in which subnet will be created
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_range

  # The AZ for the subnet
  availability_zone = var.az_public

  # Specify true to indicate that instances launched into the subnet should be assigned a public IP address
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
} 