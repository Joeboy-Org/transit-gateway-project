variable "vpc_name" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}
variable "environment" {
  type = string
}
variable "private_subnets" {
  type    = map(map(string))
  default = {}
}
variable "public_subnets" {
  type    = map(map(string))
  default = {}
}