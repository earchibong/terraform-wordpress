#  Define the VPC resource, giving it a unique name and the desired CIDR block range.
resource "aws_vpc" "vpc" {

  # The IPv4 CIDR block for the VPC
  cidr_block = var.cidr_block

  # A boolean flag to enable/disable DNS support in the VPC. Defaults to true.
  enable_dns_support = true

  tags = {
    Name = "vpc"
  }
} 