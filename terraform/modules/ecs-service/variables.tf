variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "subnets" {
  type = set(string)
}

variable "ecs_tasks_sg_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "desired_count" {
  type = number
}