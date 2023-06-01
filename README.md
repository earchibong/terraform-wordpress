## Deploy WordPress and MySQL with Terraform on AWS EC2

This is a side project i decided do to create an AWS infrastructure with VPC, public and private subnets, NAT gateway, and security groups using Terraform and deploy worpdress and mysql with docker.

<br>

<br>

![image](https://github.com/earchibong/terraform-wordpress/assets/92983658/53ff23ec-3d28-46ae-81f9-64d512ac12a8)


<br>

<br>

**Get the <a href="https://github.com/earchibong/terraform-wordpress/blob/main/documentation.md">full documentation for this project HERE</a>**

<br>

<br>

## Steps for this project include:

- Install and configure Terraform on your local system
- Install IDE for Terraform — VS Code Editor
- Create a new Terraform configuration file and specify the AWS provider details, such as the access key and secret key
- Create terraform.tfvars file with defined variables
- Create an AWS Key pair for secure ssh connections to EC2 instances
- Define the VPC resource, giving it a unique name and the desired CIDR block range.
- Create the Public Subnet with auto public IP Assignment enabled in VPC
- Create a Private Subnet in VPC
- Create an Internet Gateway for Instances in the public subnet to access the Internet
- Define a route table for the public subnet, specifying the internet gateway as the target for all internet-bound traffic
- Associate the routing table to the Public Subnet to provide Internet Gateway Address
- Create an Elastic IP for the NAT Gateway
- Create a NAT gateway for MySQL instance to access the Internet
- Create a route table for the NAT Gateway Access which has to be associated with MySQL Instance
- Associate the above-create route table with the MySQL Instance
- Create a Security Group for the Bastion Host
- Create a Security Group for the WordPress Instance
- Create a Security Group for MySQL Instance
- Launch a Bastion Host
- Launch a Webserver Instance hosting Wordpress on it
- Null Resources and Provisioners
- Launch a MySQL Instance using the bash install script
- Update variables.tf
- Update tfvars file
- Terraform Apply
- Test deployment

<br>

