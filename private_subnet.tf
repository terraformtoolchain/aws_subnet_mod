resource "aws_subnet" "private" {
	count = "${ var.private ? length(split(",", var.azs)) : 0 }"

	vpc_id = "${ var.vpc_id }"
	cidr_block = "${ cidrsubnet(var.vpc_cidr, 8, var.starting_bit_private + count.index) }"
	availability_zone = "${ element(split(",", var.azs), count.index) }"

	lifecycle {
		create_before_destroy = true
	}

	tags {
		Name = "${ var.name }-private-subnet-${ element(split(",", var.azs), count.index) }"
	}
}

resource "aws_route_table" "private" {
	count = "${ var.private ? length(split(",", var.azs)) : 0 }"

	vpc_id = "${ var.vpc_id }"

	tags {
		Name = "${ var.name }-rt-private"
	}
}

resource "aws_route" "nat_default" {
	count = "${ var.private && var.public ? length(split(",", var.azs)) : 0 }"

	route_table_id			= "${ element(aws_route_table.private.*.id, count.index) }"
	destination_cidr_block	= "0.0.0.0/0"
	nat_gateway_id			= "${ element(concat(aws_nat_gateway.nat.*.id, list("")), count.index) }"
}

resource "aws_route" "nat_private_only" {
	count = "${ var.private && !var.public ? length(split(",", var.azs)) : 0 }"

	route_table_id			= "${ element(aws_route_table.private.*.id, count.index) }"
	destination_cidr_block	= "0.0.0.0/0"
	nat_gateway_id			= "${ element(split(",", var.nat_id), count.index) }"
}


resource "aws_route_table_association" "private" {
	count = "${ var.private ? length(split(",", var.azs)) : 0 }"

	subnet_id = "${ element(aws_subnet.private.*.id, count.index) }"
	route_table_id = "${ element(aws_route_table.private.*.id, count.index) }"

	lifecycle {
		create_before_destroy = true
	}
}
