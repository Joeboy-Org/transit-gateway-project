data "aws_ec2_transit_gateway_attachment" "devops_application" {
  transit_gateway_attachment_id = "tgw-attach-068e0c18c1de02ca3"
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.this[0].id]
  }
}