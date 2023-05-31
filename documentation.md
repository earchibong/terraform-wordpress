
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
Create an AWS Key pair for secure ssh connections to EC2 instances
Define the VPC resource, giving it a unique name and the desired CIDR block range.
Create the Public Subnet with auto public IP Assignment enabled in VPC
Create a Private Subnet in VPC
Create an Internet Gateway for Instances in the public subnet to access the Internet
Define a route table for the public subnet, specifying the internet gateway as the target for all internet-bound traffic
Associate the routing table to the Public Subnet to provide Internet Gateway Address
Create an Elastic IP for the NAT Gateway
Create a NAT gateway for MySQL instance to access the Internet
Create a route table for the NAT Gateway Access which has to be associated with MySQL Instance
Associate the above-create route table with the MySQL Instance
Create a Security Group for the Bastion Host
Create a Security Group for the WordPress Instance
Create a Security Group for MySQL Instance
Launch a Bastion Host
Launch a Webserver Instance hosting Wordpress on it
Null Resources and Provisioners
Launch a MySQL Instance using the bash install script
Update your variables.tf
Update your tfvars file
Terraform Apply
Test your deployment

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

An internet gateway, enables instances in the VPC to communicate with the internet and  enables internet users to connect with instances in the VPC. This allows for the use of internet-based services and applications, such as web-based applications, content delivery networks, and other internet-based services.

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
