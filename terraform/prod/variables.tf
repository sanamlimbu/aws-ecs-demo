variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "image_tags" {
  type = map(string)
  default = {
    servicea = "latest",
    serviceb = "latest",
  }
}

variable "fargate_cpu" {
  type    = string
  default = "256"
}

variable "fargate_memory" {
  type    = string
  default = "512"
}

variable "task_count" {
  type    = number
  default = 2
}