variable "name" {
	type = "string"
	default = "default"
}

variable "azs" {
	type = "string"
	default = "us-east-1a,us-east-1b,us-east-1c"
}

variable "cost_center" {
	type = "string"
	description = "An optional tag for company cost allocation."
	default = "none"
}

variable "vpc_id" {
	type = "string"
	description = "The ID of the VPC that the subnet(s) will be located in."
}

variable "vpc_cidr" {
	type = "string"
	description = "The CIDR of the VPC that the subnet(s) will be located in."
}

variable "public" {
	description = "Boolean value that enables the creation of a public subnet."
	default = true
}

variable "starting_bit_public" {
	description = "Integer value to set the starting bit range of the generated public subnets."
	default = 1
}

variable "natEnabled" {
	description = "Boolean value that sets up network address translation in the public subnet."
	default = false
}

variable "private" {
	description = "Boolean value that enables the creation of a private subnet."
	default = false
}

variable "nat_id" {
	type = "string"
	description = "The ID of the NAT gateway for private subnets. (Required if public = false)"
	default = ""
}

variable "starting_bit_private" {
	description = "Integer value to set the starting bit range of the generated private subnets."
	default = 101
}
