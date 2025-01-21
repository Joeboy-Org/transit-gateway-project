# # # VPC Endpoint for ssm

# resource "aws_vpc_endpoint" "ssm_endpoint" {
#   count             = var.environment == "application" ? 1 : 0
#   vpc_id            = module.application_vpc[0].vpc_id
#   service_name      = "com.amazonaws.ap-southeast-2.ssm"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.vpc_endpoint_sg[0].id]
#   subnet_ids         = [module.application_vpc[0].private_subnet_id["private-subnet-A"].id]

#   private_dns_enabled = true

# }

# resource "aws_vpc_endpoint" "ssm_messages_endpoint" {
#   count             = var.environment == "application" ? 1 : 0
#   vpc_id            = module.application_vpc[0].vpc_id
#   service_name      = "com.amazonaws.ap-southeast-2.ssmmessages"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.vpc_endpoint_sg[0].id]
#   subnet_ids         = [module.application_vpc[0].private_subnet_id["private-subnet-A"].id]

#   private_dns_enabled = true

# }

# resource "aws_vpc_endpoint" "ec2_messages_endpoint" {
#   count             = var.environment == "application" ? 1 : 0
#   vpc_id            = module.application_vpc[0].vpc_id
#   service_name      = "com.amazonaws.ap-southeast-2.ec2messages"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.vpc_endpoint_sg[0].id]
#   subnet_ids         = [module.application_vpc[0].private_subnet_id["private-subnet-A"].id]

#   private_dns_enabled = true

# }