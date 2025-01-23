resource "aws_iam_role_policy" "ec2_policy" {
  name   = "${var.application}-ec2-policy"
  role   = aws_iam_role.ec2_role.id
  policy = var.json_policy
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.application}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "${var.application}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}