# locals {
#   transit_public_subnets = {
#     public-subnet-A = {
#       availability_zone = "ap-southeast-2a"
#       cidr_block        = "10.16.2.0/24"
#     }
#   }
#   transit_private_subnets = {
#     private-subnet-A = {
#       availability_zone  = "ap-southeast-2a"
#       cidr_block         = "10.16.1.0/24"
#       natgw_pub_sub_name = "public-subnet-A"
#     }
#   }
#   app_private_subnets = {
#     private-subnet-A = {
#       availability_zone = "ap-southeast-2a"
#       cidr_block        = "10.17.1.0/24"
#     }
#   }
# }