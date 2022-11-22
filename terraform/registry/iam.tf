resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.service_name}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
    }]
  })
}


resource "aws_iam_role" "ecs_task_role" {
  name = "${var.service_name}-ecsTaskRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  # Esta política otorga a las instancias los permisos necesarios para la funcionalidad principal de Systems Manager.
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  # role       = aws_iam_role.ecsTaskExecutionRole.name
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
