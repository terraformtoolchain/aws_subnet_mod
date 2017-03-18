resource "aws_internet_gateway" "public" {
	count = "${ var.public ? 1 : 0 }"

	vpc_id = "${ var.vpc_id }"

	tags {
		Name = "${ var.name }-igw"
	}
}

resource "aws_subnet" "public" {
	count = "${ var.public ? length(split(",", var.azs)) : 0 }"

	vpc_id					= "${ var.vpc_id }"
	cidr_block				= "${ cidrsubnet(var.vpc_cidr, 8, var.starting_bit_public + count.index) }"
	availability_zone		= "${ element(split(",", var.azs), count.index) }"
	map_public_ip_on_launch = true

	lifecycle {
		create_before_destroy = true
	}

	tags {
		Name		= "${ var.name }-public-subnet-${ element(split(",", var.azs), count.index) }"
	}
}

resource "aws_route_table" "public" {
	count = "${ var.public ? 1 : 0 }"

	vpc_id = "${ var.vpc_id }"

	tags {
		Name = "${ var.name }-rt-public"
	}
}

resource "aws_route" "igw" {
	count = "${ var.public ? 1 : 0 }"

	route_table_id			= "${ aws_route_table.public.id }"
	destination_cidr_block	= "0.0.0.0/0"
	gateway_id				= "${ aws_internet_gateway.public.id }"
}

resource "aws_route_table_association" "public" {
	count = "${ var.public ? length(var.azs) : 0 }"

	subnet_id		= "${ element(aws_subnet.public.*.id, count.index) }"
	route_table_id	= "${ aws_route_table.public.id }"
}

resource "aws_eip" "nat" {
	count = "${ var.natEnabled || var.private ? length(split(",", var.azs)) : 0 }"

	vpc = true
	
	lifecycle {
		create_before_destroy = true
	}

	tags {
		Cost_Center = "${ var.cost_center }"
}

resource "aws_nat_gateway" "nat" {
	count = "${ var.natEnabled && var.public ? length(split(",", var.azs)) : var.public && var.private ? length(split(",", var.azs)) : 0 }"

	allocation_id	= "${ element(aws_eip.nat.*.id, count.index) }"
	subnet_id		= "${ element(aws_subnet.public.*.id, count.index) }"

	lifecycle {
		create_before_destroy = true
	}

	tags {
		Cost_Center = "${ var.cost_center }"
	}
}
