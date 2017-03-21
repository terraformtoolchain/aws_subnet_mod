resource "aws_eip" "nat" {
	count = "${ var.natEnabled && var.public ? length(split(",", var.azs)) : 0 }"

	vpc = true
     
	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_nat_gateway" "nat" {
	count = "${ var.natEnabled && var.public ? length(split(",", var.azs)) : var.public && var.private ? length(split(",", var.azs)) : 0 }"

	allocation_id   = "${ element(aws_eip.nat.*.id, count.index) }"
	subnet_id               = "${ element(aws_subnet.public.*.id, count.index) }"

	lifecycle {
		create_before_destroy = true
	}
}
