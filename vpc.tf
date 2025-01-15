module "transit_vpc" {
  count           = var.environment == "networking" ? 1 : 0
  source          = "./modules/vpc"
  vpc_name        = "transit"
  vpc_cidr_block  = "10.16.0.0/16"
  private_subnets = local.transit_private_subnets
  public_subnets  = local.transit_public_subnets
  tgw_vpc_public_routes = {
    app_vpc_routes = {
      cidr_block         = "10.17.0.0/16"
      public_subnet_keys = keys(local.transit_public_subnets)
    }
  }
  tgw_vpc_private_routes = {
    app_vpc_routes = {
      cidr_block          = "10.17.0.0/16"
      private_subnet_keys = keys(local.transit_private_subnets)
    }
  }
  transit_gateway_id = module.transit-tgw-attachment[0].transit_gw_id
  environment        = var.environment
}

module "application_vpc" {
  count                 = var.environment == "application" ? 1 : 0
  source                = "./modules/vpc"
  vpc_name              = "devops"
  vpc_cidr_block        = "10.17.0.0/16"
  private_subnets       = local.app_private_subnets
  public_subnets        = {}
  tgw_vpc_public_routes = {}
  tgw_vpc_private_routes = {
    app_vpc_routes = {
      cidr_block          = "0.0.0.0/0"
      private_subnet_keys = keys(local.app_private_subnets)
    }
  }
  transit_gateway_id = data.aws_ec2_transit_gateway.this[0].id
  environment        = var.environment
}
