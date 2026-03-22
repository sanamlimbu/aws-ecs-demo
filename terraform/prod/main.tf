module "vpc" {
  source     = "../modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "alb" {
  source            = "../modules/alb"
  env               = local.env
  public_subnet_ids = module.vpc.public_subnet_ids
  name              = local.project
  vpc_id            = module.vpc.id
}

module "target_groups" {
  for_each          = toset(local.services)
  source            = "../modules/alb-target-group"
  name              = "${each.key}-tg-${local.env}"
  health_check_path = local.service_v1_health_paths[each.key]
  vpc_id            = module.vpc.id
}

module "listener_rules_v1" {
  for_each         = toset(local.services)
  source           = "../modules/alb-listener-rule"
  listener_arn     = module.alb.http_listener_arn
  path_pattern     = local.service_v1_paths[each.key]
  target_group_arn = module.target_groups[each.key].arn
  priority         = local.service_priorities[each.key]
}

module "ecr" {
  source   = "../modules/ecr"
  for_each = toset(local.services)
  name     = "${each.key}-${local.env}"
}

module "ecs" {
  source    = "../modules/ecs"
  env       = local.env
  vpc_id    = module.vpc.id
  name      = local.ecs_cluster_name
  alb_sg_id = module.alb.alb_sg_id
}

module "task_execution_role" {
  source  = "../modules/ecs-task-exec-role"
  env     = local.env
  project = local.project
}

module "task_definition" {
  source             = "../modules/ecs-task-definition"
  for_each           = toset(local.services)
  service            = each.key
  env                = local.env
  execution_role_arn = module.task_execution_role.arn
  image              = "${module.ecr[each.key].repository_url}:${var.image_tags[each.key]}"
  region             = var.region
  fargate_cpu        = var.fargate_cpu
  fargate_memory     = var.fargate_memory
  project            = local.project
}

module "cloudwatch" {
  source            = "../modules/cloudwatch"
  for_each          = toset(local.services)
  log_group_name    = "/ecs/${local.project}-${local.env}/${each.key}"
  retention_in_days = 14
}

module "ecs_service" {
  source              = "../modules/ecs-service"
  for_each            = toset(local.services)
  name                = each.key
  env                 = local.env
  cluster_id          = module.ecs.cluster_id
  task_definition_arn = module.task_definition[each.key].arn
  subnets             = module.vpc.public_subnet_ids
  target_group_arn    = module.target_groups[each.key].arn
  desired_count       = var.task_count
  ecs_tasks_sg_id     = module.ecs.ecs_tasks_sg_id
}

module "ecs_auto_scale_role" {
  source  = "../modules/ecs-auto-scale-role"
  project = local.project
  env     = local.env
}

module "autoscaling" {
  source                  = "../modules/auto-scaling"
  for_each                = toset(local.services)
  ecs_service_name        = module.ecs_service[each.key].name
  ecs_cluster_name        = module.ecs.cluster_name
  ecs_auto_scale_role_arn = module.ecs_auto_scale_role.arn
}