variable "environment" {
  type = string
}

variable "vpc_attachments" {
  type = map(map(string))
}

variable "vpc_id" {
  type = string
}