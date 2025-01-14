# Hello

module "transit_vpc" {
  count = var.environment == "networking" ? 1 : 0
  source = "./modules/vpc"
  vpc_name = "transit"
  vpc_cidr_block = "10.16.0.0/16"
  private_subnets = {
    private-subnet-A = {
      availability_zone       = "ap-southeast-2a"
      cidr_block              = "10.16.1.0/24"
      natgw_pub_sub_name       =  "public-subnet-A"
    }
  }
  public_subnets = {
    public-subnet-A = {
      availability_zone       = "ap-southeast-2a"
      cidr_block              = "10.16.2.0/24"
    }
  }
  environment = var.environment
}

module "application_vpc" {
  count = var.environment == "application" ? 1 : 0
  source = "./modules/vpc"
  vpc_name = "devops"
  vpc_cidr_block = "10.17.0.0/16"
  private_subnets = {
    private-subnet-A = {
      availability_zone       = "ap-southeast-2a"
      cidr_block              = "10.17.1.0/24"
    }
  }
  public_subnets = {}
  environment = var.environment
}
