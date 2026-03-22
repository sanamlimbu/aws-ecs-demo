variable "project" {
  type = string
}
variable "service" {
  type = string
}

variable "env" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "image" {
  type = string
}

variable "fargate_cpu" {
  type = string
}

variable "fargate_memory" {
  type = string
}

variable "region" {
  type = string
}

variable "task_role_arn" {
  type    = string
  default = null
}