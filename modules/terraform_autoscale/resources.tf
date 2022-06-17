# Autoscaling
resource "aws_autoscaling_group" "aws_asg" {
  name                 = "${var.autosg_name_id}"
  vpc_zone_identifier  =  ["${module.vpc.subnet_1_id}", "${module.vpc.subnet_2_id}"]
  launch_configuration = "${module.launchconfig.launch_config_id}"
  

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 100
  health_check_type         ="EC2"
  force_delete              = true

  lifecycle {
    create_before_destroy = true
  }   
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "manaya-autosg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.aws_asg.name
}
