resource "aws_ecs_cluster" "cluster" {
  name = "${service_name}-ecs"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
#  manage the infrastructure the tasks in your clusters use
resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }
}


