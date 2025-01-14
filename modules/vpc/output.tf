output "vpc_id" {
  description = "This is the id of the vpc"
  value       = aws_vpc.this.id
}

output "private_subnet_id" {
  value = aws_subnet.private
}