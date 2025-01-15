resource "aws_ec2_transit_gateway" "this" {
  count                          = var.environment == "networking" ? 1 : 0
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "${var.environment}-transit-gateway"
  }
}

resource "aws_ram_resource_share" "this" {
  count = var.environment == "networking" ? 1 : 0

  name = "${var.environment}-transitgw-ram"

  tags = {
    Name = "${var.environment}-transitgw-ram"
  }
}

# Share the transit gateway...
resource "aws_ram_resource_association" "this" {
  count = var.environment == "networking" ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.this[0].arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_principal_association" "this" {
  count = var.environment == "networking" ? 1 : 0

  principal          = var.app_account_id
  resource_share_arn = aws_ram_resource_share.this[0].id
}

# Create the VPC attachment in the second account...
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = { for key, value in var.vpc_attachments : key => value if var.environment == "networking" }

  depends_on = [
    aws_ram_principal_association.this[0],
    aws_ram_resource_association.this[0],
  ]

  subnet_ids         = each.value.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this[0].id
  vpc_id             = var.vpc_id

  tags = {
    Name = "${each.key}-vpc-attachment"
  }
}


resource "aws_ec2_transit_gateway_route_table" "transit" {
  count              = var.environment == "networking" ? 1 : 0
  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = {
    Name = "transit-tgw-route-table"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "transit" {
  count                          = var.environment == "networking" ? 1 : 0
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this["transit-tgw-attachment"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transit[0].id
}

resource "aws_ec2_transit_gateway_route" "transit" {
  for_each                       = toset(var.devops_cidrs)
  destination_cidr_block         = each.key
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_attachment.devops_application.resource_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transit[0].id
}

resource "aws_ec2_transit_gateway_route_table" "devops_application" {
  count              = var.environment == "networking" ? 1 : 0
  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = {
    Name = "devops-application-tgw-route-table"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "devops_application" {
  count                          = var.environment == "networking" ? 1 : 0
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_attachment.devops_application.resource_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.devops_application[0].id
}

resource "aws_ec2_transit_gateway_route" "devops_application" {
  for_each                       = toset(var.transit_cidrs)
  destination_cidr_block         = each.key
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this["transit-tgw-attachment"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.devops_application[0].id
}


