resource "aws_ec2_transit_gateway" "this" {
  count = var.environment == "networking" ? 1 : 0

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

  resource_arn       = aws_ec2_transit_gateway.this.arn
  resource_share_arn = aws_ram_resource_share.this.id
}

resource "aws_ram_principal_association" "this" {
  count = var.environment == "networking" ? 1 : 0

  principal          = data.aws_caller_identity.application[0].id
  resource_share_arn = aws_ram_resource_share.this.id
}

# Create the VPC attachment in the second account...
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = { for key, value in var.vpc_attachments : key => value }

  depends_on = [
    aws_ram_principal_association.this[0],
    aws_ram_resource_association.this[0],
  ]

  subnet_ids         = each.value.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_id

  tags = {
    Name = "${each.key}-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  count = var.environment == "networking" ? 1 : 0

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.this[""].id

  tags = {
    Name = "terraform-example"
  }
}
