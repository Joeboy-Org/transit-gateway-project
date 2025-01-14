output "caller_identity_application" {
  value = data.aws_caller_identity.application[0].account_id
}