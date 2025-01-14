# Hello
resource "aws_s3_bucket" "this" {
  bucket = "test-${var.environment}-${var.aws_account_id}-bucket"
}