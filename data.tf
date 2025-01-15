data "aws_ec2_transit_gateway" "this" {
  count = var.environment == "application" ? 1 : 0
  id    = "tgw-02a36e4a5e340942d"
}

data "aws_partition" "current" {}