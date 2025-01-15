locals {
  devops_application_tgw_id = "tgw-attach-01c6d01136f33167f"
}

data "aws_ec2_transit_gateway_attachment" "devops_application" {
  filter {
    name   = "transit-gateway-id"
    values = [local.devops_application_tgw_id]
  }
}