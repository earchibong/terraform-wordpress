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