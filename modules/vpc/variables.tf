variable "vpc_name" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}
variable "environment" {
  type = string
}
variable "transit_gateway_id" {
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

variable "tgw_vpc_public_routes" {
  type = map(object({
    cidr_block         = string
    public_subnet_keys = list(string)
  }))
}
variable "tgw_vpc_private_routes" {
  type = map(object({
    cidr_block          = string
    private_subnet_keys = list(string)
  }))
}