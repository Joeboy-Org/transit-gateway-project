# resource "aws_instance" "this" {
#   count                       = var.environment == "networking" || var.environment == "application" ? 1 : 0
#   ami                         = "ami-0078b36c740288eef"
#   associate_public_ip_address = false
#   instance_type               = "t3.medium"
#   vpc_security_group_ids      = [var.environment == "networking" ? aws_security_group.transit_sg[0].id : aws_security_group.devops_application_sg[0].id]
#   iam_instance_profile        = aws_iam_instance_profile.ssm_role[0].name
#   subnet_id                   = var.environment == "networking" ? module.transit_vpc[0].private_subnet_id["private-subnet-A"].id : module.application_vpc[0].private_subnet_id["private-subnet-A"].id
#   tags = {
#     "Name" = "${var.environment == "networking" ? "transit" : "devops"}-ec2-instance"
#   }
#   root_block_device {
#     encrypted   = true
#     volume_type = "gp3"
#   }
# }