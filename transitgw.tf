module "transit-tgw-attachment" {
  source      = "./modules/transit-gw"
  vpc_id      = module.transit_vpc.vpc_id
  environment = var.environment
  vpc_attachments = {
    transit-tgw-attachment = {
      subnet_ids = [module.transit_vpc.private_subnet_id["private-subnet-A"].id]
    }
  }
}

module "devops-tgw-attachment" {
  source      = "./modules/transit-gw"
  vpc_id      = module.application_vpc.vpc_id
  environment = var.environment
  vpc_attachments = {
    devops-tgw-attachment = {
      subnet_ids = [module.application_vpc.private_subnet_id["private-subnet-A"].id]
    }
  }
}