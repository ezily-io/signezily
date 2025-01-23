resource "aws_launch_template" "app" {
  name_prefix               = "${var.application}_template"
  image_id                  = local.ami
  instance_type             = var.instance_type
  key_name                  = aws_key_pair.server_key.key_name

  iam_instance_profile {
    name = var.iam_profile
  }

  network_interfaces {
    security_groups         = "${var.security_groups}"
    associate_public_ip_address = "${var.public_ip}"
  }

  block_device_mappings {
    device_name             = "/dev/sda1"

    ebs {
      volume_size           = var.root_size
    }
  }

  user_data = var.user_data

  lifecycle {
    create_before_destroy   = true
    ignore_changes = [iam_instance_profile]
  }

}

resource "aws_autoscaling_group" "asg" {
  name                    = "${var.application}_asg"
  vpc_zone_identifier     = var.subnets_ids
  min_size                = 1
  desired_capacity        = 1
  max_size                = 2
  target_group_arns       = var.target_group

  launch_template {
    id                    = aws_launch_template.app.id
    version               = aws_launch_template.app.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                   = "Name"
    value                 = "${var.application}_server"
    propagate_at_launch   = true
  }
}