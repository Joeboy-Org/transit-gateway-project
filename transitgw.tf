module "transit-tgw-attachment" {
  count          = var.environment == "networking" ? 1 : 0
  source         = "./modules/transit-gw"
  vpc_id         = module.transit_vpc[0].vpc_id
  environment    = var.environment
  app_account_id = "207567790440"
  vpc_attachments = {
    transit-tgw-attachment = {
      subnet_ids = [module.transit_vpc[0].private_subnet_id["private-subnet-A"].id]
    }
  }
}

######################
# Application Account
######################
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count              = var.environment == "application" ? 1 : 0
  subnet_ids         = [module.application_vpc[0].private_subnet_id["private-subnet-A"].id]
  transit_gateway_id = data.aws_ec2_transit_gateway.this[0].id
  vpc_id             = module.application_vpc[0].vpc_id
}