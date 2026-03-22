locals {
  project          = "aws-ecs-demo"
  env              = "prod"
  ecs_cluster_name = "${local.project}-${local.env}"
  services = [
    "servicea",
    "serviceb"
  ]
  service_v1_health_paths = {
    servicea = "/api/v1/servicea/health"
    serviceb = "/api/v1/serviceb/health"
  }
  service_v1_paths = {
    servicea = "/api/v1/servicea"
    serviceb = "/api/v1/serviceb"
  }
  service_priorities = {
    servicea = 10
    serviceb = 20
  }
}