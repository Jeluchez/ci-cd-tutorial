# define among other things, the task definition describes which container image to use.
resource "aws_ecs_task_definition" "service_task_fargate" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    image = "${var.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.service_name}:${var.image_tag}"
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = "/aws/ecs/${var.service_name}"
        awslogs-region        = var.aws_region
        awslogs-create-group  = "true"
        awslogs-stream-prefix = var.service_name
      }
    }
    portMappings = [{
      protocol      = "tcp"
      containerPort = 3000
      hostPort      = 3000
    }] }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.service_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service_task_fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.subnets.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = "${var.name}-container-${var.environment}"
    container_port   = var.container_port
  }
}


