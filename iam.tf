# resource "aws_iam_instance_profile" "ssm_role" {
#   count = var.environment == "networking" || var.environment == "application" ? 1 : 0
#   name  = "${var.environment}-ssm-instance-profile"
#   role  = aws_iam_role.ssm_role[0].name
# }

# resource "aws_iam_role" "ssm_role" {
#   count = var.environment == "networking" || var.environment == "application" ? 1 : 0
#   name  = "${var.environment}-ssm-role"

#   assume_role_policy = templatefile("${path.module}/iam/trust-policies/ec2.tpl", { none = "none" })
# }

# resource "aws_iam_role_policy_attachment" "administrator-access-attachment" {
#   count      = var.environment == "networking" || var.environment == "application" ? 1 : 0
#   role       = aws_iam_role.ssm_role[0].name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }