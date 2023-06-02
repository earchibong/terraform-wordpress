
# Deploy WordPress and MySQL with Terraform on AWS EC2

<br>

![image](https://github.com/earchibong/terraform-wordpress/assets/92983658/618cd88f-8001-427c-bbdb-c843a6843408)

<br>

<br>

## Project Steps:

- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#install-and-configure-terraform-on-your-local-system">Install and configure Terraform on local system</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#install-ide-for-terraform--vs-code-editor">Install IDE for Terraform — VS Code Editor</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-a-new-terraform-configuration-file-and-specify-the-aws-provider-details">Create a new Terraform configuration file and specify the AWS provider details</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-terraformtfvars-file-with-defined-variables">Create terraform.tfvars file with defined variables</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-an-aws-key-pair-for-secure-ssh-connections-to-ec2-instances">Create an AWS Key pair for secure ssh connections to EC2 instances</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#define-the-vpc-resource-giving-it-a-unique-name-and-the-desired-cidr-block-range">Define the VPC resource, giving it a unique name and the desired CIDR block range.</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-the-public-subnet-with-auto-public-ip-assignment-enabled-in-vpc">Create the Public Subnet with auto public IP Assignment enabled in VPC</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-a-private-subnet-in-vpc">Create a Private Subnet in VPC</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-an-internet-gateway-for-instances-in-the-public-subnet-to-access-the-internet">Create an Internet Gateway for Instances in the public subnet to access the Internet</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#define-a-route-table-for-the-public-subnet-specifying-the-internet-gateway-as-the-target-for-all-internet-bound-traffic">Define a route table for the public subnet, specifying the internet gateway as the target for all internet-bound traffic</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#associate-the-routing-table-to-the-public-subnet-to-provide-the-internet-gateway-address">Associate the routing table to the Public Subnet to provide Internet Gateway Address</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-an-elastic-ip-for-the-nat-gateway">Create an Elastic IP for the NAT Gateway</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-a-nat-gateway-for-mysql-instance-to-access-the-internet">Create a NAT gateway for MySQL instance to access the Internet</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-a-route-table-for-the-nat-gateway-access-which-has-to-be-associated-with-mysql-instance">Create a route table for the NAT Gateway Access which has to be associated with MySQL Instance</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#associate-the-nat-gateway-access-route-table-with-the-mysql-instance">Associate the above-create route table with the MySQL Instance</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-a-security-group-for-the-bastion-host">Create a Security Group for the Bastion Host</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-a-security-group-for-the-wordpress-instance">Create a Security Group for the WordPress Instance</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#create-a-security-group-for-mysql-instance">Create a Security Group for MySQL Instance</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#launch-a-bastion-host">Launch a Bastion Host</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#launch-a-webserver-instance-hosting-wordpress-on-it">Launch a Webserver Instance hosting Wordpress on it</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#null-resource-and-provisioners">Null Resources and Provisioners</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#launch-a-mysql-instance-using-the-bash-install-script">Launch a MySQL Instance using the bash install script</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#update-variablestf-file">Update variables.tf file</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#update-tfvars-file">Update tfvars file</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#terraform-init-validate-and-apply">Terraform init, validate and apply</a>
- <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md#test-the-deployment">Test the deployment</a>

<br>

<br>

## Install and configure Terraform on your local system
Download Terraform: https://www.terraform.io/downloads.html

```

# Copy binary zip file to a folder
mkdir /Users/<YOUR-USER>/Documents/terraform-install
COPY Package to "terraform-install" folder

# Unzip
unzip <PACKAGE-NAME>
unzip terraform_0.14.3_darwin_amd64.zip

# Copy terraform binary to /usr/local/bin
echo $PATH
mv terraform /usr/local/bin

# Verify Version
terraform version

# To Uninstall Terraform (NOT REQUIRED)
rm -rf /usr/local/bin/terraform

```

<br>

<br>

## Install IDE for Terraform — VS Code Editor

[Microsoft Visual Studio Code Editor](https://code.visualstudio.com/download)

[Hashicorp Terraform Plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)


<br>

<br>

## Create a new Terraform configuration file and specify the AWS provider details
- create a folder named: `terraform-wordpress`
- in `terraform-wordpress` create a new file `provider.tf` and add the following:

```

# Terraform Block
terraform {
  required_version = ">= 1.0" # any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  # Name of the region in which your environment will be deployed
  region = var.region

  # Name of your AWS profile
  profile = var.profile
}


```

<br>

<br>

**AWS provider:** is a term used in the context of infrastructure as code (IaC) tools such as Terraform. In this context, the AWS provider is a plugin for Terraform that allows it to interact with resources in Amazon Web Services (AWS). This includes creating, updating, and deleting resources such as Amazon EC2 instances and Amazon S3 buckets.

<br>

<br>

<img width="1008" alt="provider" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/bca0a19c-4be9-4fe4-b3a2-8c74a6fe13bf">

<br>

<br>

<br>


- create a file named `variables.tf` and add the following:

```

# INPUT VARS
## General Vars
variable "region" {
  description = "Provides details about a specific AWS region."
  type        = string
}

variable "profile" {
  description = "Assign the profile name here"
  type        = string
}

# base_path for refrencing 
variable "base_path" {}


```

<br>

Variables in terraform, are used to define values that can be passed into the infrastructure as code (IaC) templates and used throughout the configuration. Variables can be defined within the Terraform configuration file itself, or in external variable files.

<br>

<br>

<img width="1023" alt="variable" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/11eb4ba1-d0cb-49c1-8f58-62e474813d69">

<br>

<br>

## Create terraform.tfvars file with defined variables

Terraform uses the `.tfvars` file to load variables for a configuration. The .tfvars file is a way to set variables in the configuration file.
Terraform variable files use the “.tfvars” file extension and typically contain the values of your variables in a key-value format.

The .tfvars file is optional, but it can be a convenient way to set variables for your configuration. If you have a `.tfvars` file in the same directory as your ``.tf configuration file, Terraform will automatically load the variables from it when you run terraform apply.

Get more info on `tfvars` files <a href="https://spacelift.io/blog/terraform-tfvars">here</a>

<br>

- create a file named `terraform.tfvars` and add the following:

```

# General
region = "us-east-1"
profile	= "default"
keypair = "tf-deploy"
base_path  = "[YOUR-LOCAL-FILE-PATH]"

```

<br>

<br>

<img width="1008" alt="tfvars" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/7961e200-c424-4d74-9694-72d6549e0a02">


<br>

<br>

## Create an AWS key pair for secure ssh connections to EC2 instances

Key pairs are important for maintaining the security of AWS resources. They allow you to securely access your resources and ensure that only you (or others who have the private key) can access them.

- create a file named `keypair.tf` and add the following:

```

# Private Key and Keypair
## Create a key with RSA algorithm with 4096 rsa bits
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## Create a key pair using above private key
resource "aws_key_pair" "keypair" {

  # Name of the Key
  key_name = var.keypair

  public_key = tls_private_key.private_key.public_key_openssh
  depends_on = [tls_private_key.private_key]
}

## Save the private key at the specified path
resource "local_file" "save-key" {
  content  = tls_private_key.private_key.private_key_pem
  filename = "${var.base_path}/${var.keypair}.pem"
}

```

<br>

<br>

<img width="1025" alt="keypair" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/e4ea833a-0414-405a-b3b3-b9371ceaee43">

<br>

<br>


## Define the VPC resource, giving it a unique name and the desired CIDR block range

Virtual Private Cloud (VPC) is a logically isolated section of the AWS Cloud, where users can launch AWS resources in a virtual network that they define. They allow users to define and customise the network settings of their AWS resources, including the IP address range, subnets, and network gateways. They provide a secure and scalable environment for deploying and running AWS resources and allow for the use of both public and private IP addresses. They also support VPN and Direct Connect connections for secure, private communication with other networks.

<br>

- create a file named `vpc.tf` and add the following:

```

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

```

<br>

<br>

<img width="1030" alt="vpc" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/9e72c9db-5a07-4e16-91cd-303c73f0816a">

<br>

<br>

## Create the Public Subnet with auto public IP Assignment enabled in VPC
Instances in a private subnet can only communicate with other resources within the VPC, and cannot directly access the internet. Whereas, instances in a public subnet can communicate with the internet, and vice versa because a public subnet is a subnet in a Virtual Private Cloud (Amazon VPC) that has been configured to allow inbound and outbound internet traffic.

- create a file named `subnet-public.tf` and add the following:

```

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

```

<br>

<br>

<img width="1030" alt="subnet" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/2397854c-4904-4c07-a106-2129df1c5f50">

<br>

<br>

*note: the `depends_on` attribute can be used to specify dependencies between resources. If resource A depends on resource B, it means that resource B must be created before resource A can be created. In this case, the `vpc` must be created first before the subnet resource can be created*

<br>

<br>

## Create a Private Subnet in VPC

Private subnets do the opposite of public subnets. They cannot communicate with the internet and vice-versa. Instead, instances in a private subnet can only communicate with other resources within the VPC.

<br>

- create a file named `private-subnet.tf`

```

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

```

<br>

*note: the `private subnet, depends on the vpc and public subnet and so cannot be created until the other two resources are created first*

<br>

<br>

<img width="1027" alt="subnet_private" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/cdad5b60-717b-454f-82c0-ff9e4e09e7f4">

<br>

<br>


## Create an Internet Gateway for Instances in the public subnet to access the Internet

An internet gateway provides a connection point between a private network (such as a VPC in AWS) and the public internet. It enables communication between resources in the private network and the internet.

An internet gateway allows both inbound and outbound traffic to pass through it. Inbound traffic from the internet can be directed to specific resources in the private network based on network configurations and security rules.

Internet gateways are associated with public IP addresses, allowing resources within the private network to have public-facing IP addresses accessible from the internet.

<br>

<br>

- create a file named `igw.tf` and add the following:

```

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet
  ]

  # VPC in which IGW will be created
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

```

<br>

<br>

## Define a route table for the public subnet, specifying the internet gateway as the target for all internet-bound traffic


Route Tables are used to control the flow of network traffic in a VPC (Virtual Private Cloud). Each route table is associated with a subnet and specifies the available routes and the targets for each route.

Targets can include local subnets, internet gateways, virtual private gateways, and other network interfaces.

Route tables also have a default route for internet traffic, which can be used to route internet traffic to an internet gateway or a NAT (Network Address Translation) device. THey also allow users to customise the network traffic flow in their VPC to meet the specific requirements of their applications and workloads.

<br>

<br>

- create a file named `rt.tf` and add the following:

```

Define a route table for the public subnet, specifying the internet gateway as the target for all internet-bound traffic.
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

```

<br>

<br>

<img width="1031" alt="t" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/26042855-0efe-4be9-98e4-879b3f708d35">

<br>

<br>

## Associate the routing table to the Public Subnet to provide the Internet Gateway address

A route table association is a connection between a route table and a subnet. Each subnet in a VPC (Virtual Private Cloud) must be associated with a route table, which specifies the available routes and the targets for each route.

<br>

- create a file named `rt-association.tf` and add the following:

```

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

```

<br>

<br>

<img width="1025" alt="rt_association" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/fd0b54e5-c787-4794-85bc-17ac15831ccc">

<br>

<br>

* This configuration allows for the customisation of network traffic flow in the VPC and enables the use of internet-based services and applications.*

<br>

<br>

## Create an Elastic IP for the NAT Gateway

Elastic IPs allows users to allocate and associate a public IP address with an AWS resource. EIPs are useful for providing a fixed, public IP address for resources that need to be accessed from the internet, such as web servers or databases. They can be used with AWS resources such as EC2 instances, NAT gateways, and network interfaces. Even if the resource is behind a network address translation (NAT) device or a firewall, with an allocated Elastic IP, the resources can be accessed from the internet. 

<br>

<br>

 cfreate a file named `nat-gateway-eip.tf` and add the following:
 
 ```
 
 # Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat-gateway-eip" {
  depends_on = [
    aws_route_table_association.rt-association
  ]

  vpc = true
}

```

<br>

<br>

<img width="1028" alt="eip" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/e568ce2d-68d2-4b4f-b822-23d45336fcea">

<br>

<br>

## Create a NAT Gateway for MySQL instance to access the Internet
A NAT gateway allows private network resources to communicate with the internet while maintaining a level of network security. It performs Network Address Translation, which translates private IP addresses of resources within a private network to a single public IP address when communicating with the internet.

NAT gateways help hide the internal IP addresses of a private network from the public internet, providing a level of security by obscuring the internal network structure. It allows private instances to access the internet for updates and patches while maintaining the security of the private subnet.

<br>

<br>

- create a file named `nat-gateway.tf` and add the following:

```

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

```

<br>

<br>

<img width="1026" alt="nat-gatway" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/3d94be1b-d2d5-4070-938a-ccca68b615e4">

<br>

<br>

## Create a route table for the NAT Gateway Access which has to be associated with MySQL Instance

Any traffic destined for the CIDR block of the MySQL instance will now be routed through the NAT gateway.


- create a file named `rt-ng.tf` and add the following:

```

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

```

<br>

<br>

<img width="1026" alt="rt-ng" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/df0c6d3f-1cb2-4143-acc0-e30b0f4fd8b9">

<br>

<br>

## Associate the NAT gateway access route table with the MySQL instance

- create a file named `rt-association-ng.tf` and add the following:

```

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

```

<br>

<br>

<img width="1026" alt="rt-association-ng" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/ed58755f-3417-4d3c-8940-1edf2ea81ada">

<br>

<br>

## Create a Security Group for the Bastion Host

To secure SSH connections to instances in the private subnet, you can launch a bastion host in the public subnet. The security group for the bastion host should allow incoming SSH connections from anywhere, or from a specific IP address for added security.

We will configure the security group to allow incoming traffic on port 80 for HTTP and port 22 for SSH from the bastion host.

<br>

<br>

- create a file named `sg-bastion.tf` and add the following:

```

# Creating a Security Group for the Bastion Host which allows anyone in the outside world to access the Bastion Host by SSH.
resource "aws_security_group" "bastion-sg" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet
  ]

  # Name of the security group for Bastion Host
  name        = "bastion-sg"
  description = "MySQL Access only from the Webserver Instances!"

  # VPC ID in which Security group will be created
  vpc_id = aws_vpc.vpc.id

  # Create an inbound rule for Bastion Host SSH
  ingress {
    description = "Bastion Host SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Network Traffic from the Bastion Host
  egress {
    description = "Outbound from Bastion Host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-security-group"
  }
}


```

<br>

<br>

<img width="1031" alt="sg_bastion" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/24a45135-4d3a-48b8-887c-329c6e396e00">


<br>

<br>

## Create a Security Group for the WordPress instance

A security group acts as a virtual firewall that controls inbound and outbound traffic for cloud resources such as virtual machines (VMs) or instances.

Security groups allow you to specify which traffic is allowed to reach your instances, based on a range of security rules that you define. These rules specify the protocols, ports, and source IP ranges that are allowed to access your instances. Security groups provide an additional layer of security for your AWS environment.

<br>

<br>

- create a file named `sg-wp.tf` and add the following:

```

# Create a Security Group for the WordPress instance, so that anyone in the outside world can access the instance by HTTP, PING, SSH
resource "aws_security_group" "wp-sg" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet
  ]

  # Name of the webserver security group
  name        = "webserver-sg"
  description = "Allow outside world to access the instance via HTTP, PING, SSH"

  # VPC ID in which Security group has to be created!
  vpc_id = aws_vpc.vpc.id

  # Create an inbound rule for webserver HTTP access
  ingress {
    description = "HTTP to Webserver"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Create an inbound rule for PING
  ingress {
    description = "PING to Webserver"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Create an inbound rule for SSH access
  ingress {
    description = "SSH to Webserver"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outward Network Traffic from the WordPress webserver
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Wordpress Security Group"
  }
}


```

<br>

<br>

<img width="1028" alt="sg" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/97b43170-29ac-4d2e-86ee-42cf0aa77de9">


<br>

<br>

## Create a Security Group for MySQL instance

The security group for the MySQL instance should allow incoming connections on port 3306 from the WordPress instance, using the security group ID of the WordPress instance in the inbound rule. It should also allow incoming SSH connections on port 22 from the bastion host, using the security group ID of the bastion host in the inbound rule. This will ensure that only the WordPress instance can connect to the MySQL instance on port 3306, and only the bastion host can SSH into the MySQL instance.

Using security group IDs in the inbound rules has several advantages. It allows you to avoid having to update the rules when the public IP addresses of the instances change, and it makes it easier to scale your instances without having to create separate inbound rules for each instance.

<br>

<br>

- create a file named `sg-mysql-tf` and add the following:

```

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


```

<br>

<br>

<img width="1023" alt="sg-mysql" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/f0570f29-765d-4967-bd6c-0eceb3d06ccf">

<br>

<br>

## Launch a Bastion Host
A Bastion host is a special type of EC2 instance that allows you to securely connect to your instances over the internet. It acts as a secure, intermediary connection point between your local computer and the instances in your AWS VPC.

It provides access to a private network from an external network, such as the Internet. Bastion hosts are the only points of entry into the private network from external or untrusted networks. They serve as a single access point, reducing the attack surface and allowing organizations to implement stricter security controls and monitoring.

The bastion host can be launched using the Amazon Linux 2 AMI and a t2.micro instance type. You can attach the key created earlier to the bastion host, and use a Terraform file provisioner to copy the key from your local machine to the bastion host (we will do this in Step 21 using null resources and provisioners). This will allow you to SSH from the bastion host to the instances in the private subnet using the same key. However, for added security, it is recommended to use different keys for each instance.

<br>

<br>

- create a file named `ec2-bastion.tf` and add the following:

```

# Launch a Bastion Host
resource "aws_instance" "bastion" {
  depends_on = [
    aws_instance.wordpress,
    aws_instance.mysql
  ]

  # AMI ID - Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public-subnet.id

  key_name = var.keypair

  # Attach Bastion Security Group
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]

  tags = {
    Name = "bastion"
  }
}

```

<br>

<br>

<img width="1027" alt="ec2-bastion" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/e53b757e-3a88-441f-aa3e-b44a1d55d5b7">

<br>

<br>

## Launch a Webserver Instance hosting WordPress on it

we will use an Amazon Linux 2 AMI to launch a public-facing web application, such as WordPress, in a public subnet.

- create a file named `ec2-wp.tf` and add the following:

```

# Launch a Webserver Instance hosting WordPress in it.
resource "aws_instance" "wordpress" {
  depends_on = [
    aws_vpc.vpc,
    aws_subnet.public-subnet,
    aws_subnet.private-subnet,
    aws_security_group.bastion-sg,
    aws_security_group.mysql-sg
  ]

  # AMI ID - Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public-subnet.id

  key_name = "tf-deploy"

  # Security groups to use
  vpc_security_group_ids = [aws_security_group.wp-sg.id]

  tags = {
    Name = "wordpress"
  }
}


```

<br>

<br>

<img width="1025" alt="ec2-wp" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/1b2e91a3-60fb-4a97-bcfb-cb6723f7f63c">


<br>

<br>

## Null Resource and Provisioners

In the context of infrastructure as code (IaC) tools like Terraform, a Null Resource and Provisioners are used to perform additional actions or execute commands that are not directly related to creating or managing resources.

Provisioners in Terraform are used to define actions that should be performed on a resource after it is created or updated. Provisioners allow you to run scripts or execute commands on the target resource to perform tasks such as configuration, software installations, or initial setup. Although, it should be mentioned here that it's generally recommended to use configuration management tools like Ansible or Chef for more extensive and complex configuration management tasks.

A Null Resource in Terraform is a resource type that does not represent an actual infrastructure object. Instead, it serves as a placeholder or an empty container where you can define arbitrary actions or dependencies between resources. It allows you to execute arbitrary code or trigger external operations during the Terraform lifecycle.

The Null Resource is typically used in scenarios where you need to perform certain tasks that do not have a corresponding resource type or need to orchestrate actions between resources. For example, you might use a Null Resource to execute a shell script, call an external API, generate configuration files, or perform complex calculations.

Null Resources don't have any inherent state or properties, and they do not create or manage any infrastructure resources. They are solely used to execute actions as part of the Terraform execution plan and lifecycle.

In this context, We will use provisioners to automate the installation and configuration of WordPress, including the installation of Docker, pulling the WordPress image from Docker Hub, and launching a WordPress container with the image. You can pass environment variables to the script to configure the WordPress container for a MySQL database, and set up port forwarding from the Docker host to the Docker container on port 80. You can use the same key for this instance as you used for the bastion host.

<br>

<br>

- create a file named `null-provisioners.tf` and add the following:

```

# Create Bastion Null Resource and Provisioners
resource "null_resource" "bastion-provisioners" {
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_instance.bastion.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("${var.base_path}/${var.keypair}.pem")
  }

  ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = local_file.save-key.filename
    destination = "/tmp/terraform-key.pem"
  }
}

# Create Wordpress Null Resource and Provisioners
resource "null_resource" "wp-provisioners" {
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_instance.wordpress.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("${var.base_path}/${var.keypair}.pem")
  }

  ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = local_file.save-key.filename
    destination = "/tmp/terraform-key.pem"
  }

  ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  ## Install docker, start and enable the service, pull wordpress image and create the container
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-key.pem",
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo systemctl restart docker && sudo systemctl enable docker",
      "sudo docker pull wordpress",
      "sudo docker run --name wordpress -p 80:80 -e WORDPRESS_DB_HOST=${aws_instance.mysql.private_ip} -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=wordpressdb -d wordpress"
    ]
  }

  ## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  /*  provisioner "local-exec" {
    command = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when = destroy
    #on_failure = continue
  }  
  */
  # Creation Time Provisioners - By default they are created during resource creations (terraform apply)
  # Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)
}


```

<br>

<br>

## Launch a MySQL Instance using the bash install script

To launch an EC2 instance for MySQL in a private subnet, we can use an Amazon Linux 2 AMI and pass a script in the user data. 

- create a file named `ec2-mysql.tf`

```

# Launch a Webserver Instance hosting WordPress in it.
resource "aws_instance" "mysql" {
  depends_on = [
    aws_instance.wordpress
  ]

  # AMI ID - Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  ami           = var.ami
  user_data     = file("mysql-install.sh")
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private-subnet.id

  key_name = var.keypair

  # Attaching 2 security groups here, 1 for the MySQL Database access by the Web-servers,
  # & other one for the Bastion Host access for applying updates & patches! 
  
  vpc_security_group_ids = [aws_security_group.mysql-sg.id, aws_security_group.bastion-sg.id]

  tags = {
    Name = "mysql"
  }
}


```

<br>

<br>

<img width="1026" alt="ec2-mysql" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/211a8cdc-3ed3-4da6-8be3-8325b76e5e31">


<br>

<br>

Since we don’t need to pass any Terraform attributes to this script, you can create a `separate .sh` file and pass it to the EC2 user data using the file function. This script can be used to automate the installation and configuration of MySQL on the EC2 instance. Previously, we created 2 security groups (Steps 16 & 18) to secure the MySQL instance by configuring the security group to only allow incoming connections from the WordPress (for MySQL Database access) and Bastion (for updates & patches) instances in the public subnet. This will help to prevent unauthorised access to the MySQL database.

<br>

<br>

- create a file named `mysql-install.sh`

```

#! /bin/bash
yum update
yum install docker -y
systemctl restart docker
systemctl enable docker
docker pull mysql
docker run --name mysql -e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_DATABASE=wordpressdb -p 3306:3306 -d mysql:5.7

```

<br>

<br>

<img width="1025" alt="nysql-install" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/fcad0504-5b43-4d27-b0ac-5d624b12df56">


<br>

<br>

Using this bash script will install and enable Docker, and then pull the mysql:5.7 image from Docker Hub. It will then launch a container using this image and pass the required environment variables to configure the MySQL server. It will also set up port forwarding from the Docker host to the Docker container on port 3306.

<br>

<br>

## Update variables.tf file

```

# Input Vars
## Generic Vars
variable "region" {
  description = "Provides details about a specific AWS region."
  type        = string
}

variable "profile" {
  description = "Assign the profile name here"
  type        = string
}

variable "keypair" {
  description = "Adding the SSH authorized key"
  type        = string
}

# base_path for refrencing 
variable "base_path" {}

## VPC Vars
variable "cidr_block" {
  description = "Tags to set on the bucket"
  type        = string
}

## Public Subnet Vars
variable "public_subnet_range" {
  description = "IP Range of this subnet"
  type        = string
}

variable "az_public" {
  description = "AZ of this subnet"
  type        = string
}

## Private Subnet Vars
variable "private_subnet_range" {
  description = "IP Range of this subnet"
  type        = string
}

variable "az_private" {
  description = "AZ of this subnet"
  type        = string
}

## EC2 Wordpress Vars
variable "ami" {
  description = "AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the instance. "
  type        = string
}


```

<br>

<br>

## Update tfvars file

```

# General
region    = "eu-west-2"
profile   = "default"
keypair   = "tf-deploy"
base_path = "[YOUR_FILE_PATH]"

# VPC
cidr_block = "10.0.0.0/16"

# Subnets
public_subnet_range  = "10.0.1.0/24"
az_public            = "eu-west-2a"
private_subnet_range = "10.0.2.0/24"
az_private           = "eu-west-2b"

# EC2 WordPress
ami           = "ami-0a6006bac3b9bb8d3"
instance_type = "t2.micro"

```

<br>

<br>

<img width="1028" alt="tfvars2" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/5ff6125a-2957-4429-88bb-47474f2ea75b">


<br>

<br>

## Terraform init, validate and Apply

```

terraform init
terraform validate
terraform apply

```

<br>

<br>

<img width="924" alt="apply-complete" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/75352b18-3bba-46e1-8253-5138a9f3ec32">

<br>

<br>

## Test the deployment

### Remote access to bastion host & from there access MySQL remotely
```

# Test ssh access to bastion host
ssh ec2-user@[BASTION_PUBLIC_IP] -i private-key/tf-deploy.pem 

# Test ssh access from bastion host to mysql
ssh ec2-user@[MYSQL_PRIVATE_IP] -i /tmp/terraform-key.pem

```

<br>

<br>

<img width="1137" alt="test-bastion-mysql" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/2f99f33e-e651-4cab-bf5f-4bdae19ac106">

<br>

<br>

### Wordpress

Once all the infrastructure has been provisioned, you can access the WordPress instance by copying its public IP address and pasting it into a web browser. Since we have already passed the required environment variables to the WordPress container, you don’t need to configure WordPress for MySQL. You can simply select a language and create an account to get started using WordPress.

<br>

<br>

<img width="1387" alt="wordpress" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/a5e99a4d-c4a0-45e0-9c2d-54933ef11ff5">


<br>

<br>

