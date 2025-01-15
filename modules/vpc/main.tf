resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each                = { for key, value in var.public_subnets : key => value if var.public_subnets != {} }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-${var.environment}-${each.key}"
  }
}
resource "aws_subnet" "private" {
  for_each                = { for key, value in var.private_subnets : key => value if var.private_subnets != {} }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-${var.environment}-${each.key}"
  }
}

resource "aws_internet_gateway" "this" {
  count  = var.environment == "networking" ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-${var.environment}-igw"
  }
}

resource "aws_eip" "this" {
  count  = var.environment == "networking" ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  for_each      = { for key, value in var.public_subnets : key => value if var.public_subnets != {} }
  allocation_id = aws_eip.this[0].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.vpc_name}-${var.environment}-${each.key}-natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this[0]]
}

resource "aws_route_table" "public" {
  for_each = { for key, value in var.public_subnets : key => value if var.public_subnets != {} }
  vpc_id   = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-${var.environment}-${each.key}-route-table"
  }
}

resource "aws_route_table" "private" {
  for_each = { for key, value in var.private_subnets : key => value if var.private_subnets != {} }
  vpc_id   = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-${var.environment}-private-route-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = { for key, value in var.public_subnets : key => value if var.public_subnets != {} && var.environment == "networking" }
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = { for key, value in var.private_subnets : key => value if var.private_subnets != {} }
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route" "public" {
  for_each               = { for key, value in var.public_subnets : key => value if var.public_subnets != {} && var.environment == "networking" }
  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route" "private" {
  for_each               = { for key, value in var.private_subnets : key => value if var.private_subnets != {} && var.environment == "networking" }
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.value.natgw_pub_sub_name].id
}

resource "aws_route" "tgw_public_routes" {
  for_each = merge([
    for route_key, route_value in var.tgw_vpc_public_routes : {
      for subnet_key in route_value.public_subnet_keys : route_key => {
        cidr_block = route_value.cidr_block
        subnet_key = subnet_key
      }
      if var.tgw_vpc_public_routes != {} && var.environment == "networking"
    }
  ]...)

  route_table_id         = aws_route_table.public[each.value.subnet_key].id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route" "tgw_private_routes" {
  for_each = merge([
    for route_key, route_value in var.tgw_vpc_private_routes : {
      for subnet_key in route_value.private_subnet_keys : route_key => {
        cidr_block = route_value.cidr_block
        subnet_key = subnet_key
      }
      if var.tgw_vpc_public_routes != {}
    }
  ]...)
  route_table_id         = aws_route_table.private[each.value.subnet_key].id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = var.transit_gateway_id
}
