# define among other things, the task definition describes which container image to use.
resource "aws_ecs_task_definition" "service_task_fargate" {
  network_mode             = "awsvpc"
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.service_name}",
      "image": "${var.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.service_name}:${var.image_tag}",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${var.service_name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-create-group": "true",
          "awslogs-stream-prefix": "${var.service_name}"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
          "protocol": "tcp"
        }
      ]
    }
  ]
  DEFINITION
}

#  service definition that makes the task in the cluster accessible to the external world.
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.service_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service_task_fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.my_app.arn
    container_name   = var.service_name
    container_port   = 3000
  }
  network_configuration {
    security_groups  = [aws_security_group.lb.id, aws_security_group.https.id]
    subnets          = [aws_subnet.public1.id, aws_subnet.public2.id]
    assign_public_ip = true
  }

}


