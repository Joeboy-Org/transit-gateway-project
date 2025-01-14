module "transit-tgw-attachment" {
  count          = var.environment == "networking" ? 1 : 0
  source         = "./modules/transit-gw"
  vpc_id         = module.transit_vpc[0].vpc_id
  environment    = var.environment
  app_account_id = data.aws_caller_identity.application[0].account_id
  vpc_attachments = {
    transit-tgw-attachment = {
      subnet_ids = [module.transit_vpc[0].private_subnet_id["private-subnet-A"].id]
    }
  }
}

module "devops-tgw-attachment" {
  count       = var.environment == "application" ? 1 : 0
  source      = "./modules/transit-gw"
  vpc_id      = module.application_vpc[0].vpc_id
  environment = var.environment
  app_account_id = data.aws_caller_identity.application[0].account_id
  vpc_attachments = {
    devops-tgw-attachment = {
      subnet_ids = [module.application_vpc[0].private_subnet_id["private-subnet-A"].id]
    }
  }
}