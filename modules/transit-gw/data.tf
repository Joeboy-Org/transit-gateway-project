data "aws_ec2_transit_gateway_attachment" "devops_application" {
  transit_gateway_attachment_id = "tgw-attach-01c6d01136f33167f"
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.this[0].id]
  }
}