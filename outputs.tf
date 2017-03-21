output "nat_ids" {
	value = "${ join(",", aws_nat_gateway.nat.*.id) }"
}

output "public_subnet_ids" {
	value = "${ join(",", aws_subnet.public.*.id) }"
}

output "private_subnet_ids" {
	value = "${ join(",", aws_subnet.private.*.id) }"
}
