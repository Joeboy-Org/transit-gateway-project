# data "aws_caller_identity" "application" {
#   count = var.environment == "application" ? 1 : 0
# }