# AWS Subnet Terraform Module

A highly configurable Terraform module that gives the user the ability to create public or private subnets.

## Design Philosophy

There is a need for a general purpose AWS subnet module that abstracts away the differences between public and private subnets. The module is designed to fully configure the networking of one service within a VPC. While it is possible to make a private and public subnet at the same time, it is not advised. The reasoning for this decoupling is because each availability zone in a VPC may have many private subnets (databases, applications, maintainence), but only require one public subnet (reverse proxys, VPN Bastion, SSH Bastion). This module is meant to be used as a `public=true & natEnabled=true` module only once and reused many times over as a private subnet that pulls the `nat_id` from the module with the public configuration, whether it be in local or remote state.

## Module Input Variables

- `name` - The name of the service that the subnet(s) are hosting. Set to VPC name if `public` = true.
- `azs` - The availability zones the subnet will be configured to host instances in. (default = "us-east-1a,us-east-1b,us-east-1c")
- `cost_center` - A tag for company cost allocation. (optional)
- `vpc_id` - The ID of the VPC that the subnet(s) will be located in. (Required) 
- `vpc_cidr` - The CIDR of the VPC that the subnet(s) will be located in. (Required) 
- `public` - Boolean value that enables the creation of a public subnet. (default = true)
- `starting_bit_public` - Integer value to set the starting bit range of the generated public subnets. The default value is a good default value. Don't touch this unless you know what you're doing or if for some reason you need more than one public subnet in your VPC. (default = 1) 
- `natEnabled` - Boolean value that sets up network address translation in the public subnet. Sets up NAT gateways in all public subnets which allows instances in private subnets to access the internet. Must be set to true if you plan on using private subnets in the future. Do not use if module variables `public` and `private` are both set to true. (default = false) 
- `private` - Boolean value that enables the creation of a private subnet. (default = false)
- `nat_id` - The ID of the NAT gateway for private subnets. (Required if public = false) 
- `starting_bit_private` - Integer value to set the starting bit range of the generated private subnets. This default must be changed every time this module is used to make a public subnet.  

## Module Outputs

- `nat_ids` - The nat ID(s) within the subnet(s). 
