variable "environment" {
  type = string
}

variable "vpc_attachments" {
  type = map(object({
    subnet_ids = list(string)
  }))
}

variable "vpc_id" {
  type = string
}

variable "app_account_id" {
  type = string
}