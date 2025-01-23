# ECS task execution IAM role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs${var.type}Role-${var.application}-${var.environment}"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

# ECS task execution IAM permissions
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  count = var.type == "Execution" ? 1 : 0
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS task IAM policy
resource "aws_iam_policy" "custom_policy" {
  name        = "AmazonECS${var.type}Role_CustomPolicy_${var.application}_${var.environment}"
  description = "Custom policy for ECS task role."
  policy      = var.json_policy
}

# ECS task execution IAM permissions
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-custom-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.custom_policy.arn
}