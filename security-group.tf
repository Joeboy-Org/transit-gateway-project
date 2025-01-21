# resource "aws_security_group" "transit_sg" {
#   count       = var.environment == "networking" ? 1 : 0
#   name        = "transit-${var.environment}-ec2-sg"
#   description = "Attached to EC2 Instances in the networking account"
#   vpc_id      = module.transit_vpc[0].vpc_id

#   ingress {
#     description = "Allow ICMP (Ping) from a devops application CIDR"
#     from_port   = -1               # For ICMP, use -1 for all types
#     to_port     = -1               # For ICMP, use -1 for all codes
#     protocol    = "icmp"           # Specify ICMP protocol
#     cidr_blocks = ["10.17.0.0/16"] # Replace with your CIDR block
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "devops_application_sg" {
#   count       = var.environment == "application" ? 1 : 0
#   name        = "devops-${var.environment}-ec2-sg"
#   description = "Attached to EC2 Instances in the application account"
#   vpc_id      = module.application_vpc[0].vpc_id

#   ingress {
#     description = "Allow ICMP (Ping) from a transit CIDR"
#     from_port   = -1               # For ICMP, use -1 for all types
#     to_port     = -1               # For ICMP, use -1 for all codes
#     protocol    = "icmp"           # Specify ICMP protocol
#     cidr_blocks = ["10.16.0.0/16"] # Replace with your CIDR block
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "vpc_endpoint_sg" {
#   count       = var.environment == "application" ? 1 : 0
#   name        = "devops-${var.environment}-vpce-sg"
#   description = "Attached to vpc endpoint in the application account"
#   vpc_id      = module.application_vpc[0].vpc_id

#   ingress {
#     description = "Allow Http from a devops vpc subnet CIDR"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["10.17.1.0/24"]
#   }
#   ingress {
#     description = "Allow Https from a devops vpc subnet CIDR"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["10.17.1.0/24"]
#   }
# }