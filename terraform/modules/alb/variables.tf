variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "public_subnet_ids" {
  type = set(string)
}

variable "vpc_id" {
  type = string
}