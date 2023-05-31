
# Deploy WordPress and MySQL with Terraform on AWS EC2


<br>

## Project Steps:

Install and configure Terraform on local system
Install IDE for Terraform — VS Code Editor
Create a new Terraform configuration file and specify the AWS provider details, such as the access key and secret key
Create terraform.tfvars file with defined variables
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

<br>

Variables in terraform, are used to define values that can be passed into the infrastructure as code (IaC) templates and used throughout the configuration. Variables can be defined within the Terraform configuration file itself, or in external variable files.

<br>

<br>

<img width="1023" alt="variable" src="https://github.com/earchibong/terraform-wordpress/assets/92983658/11eb4ba1-d0cb-49c1-8f58-62e474813d69">

<br>

<br>


