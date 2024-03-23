resource "aws_autoscaling_group" "terraform" {
  name                 = "terraform-asg"
  launch_configuration = aws_launch_configuration.autoscale_config.name
  
  min_size             = var.min_capacity
  max_size             = var.max_capacity
  desired_capacity     = var.desired_capacity
  count=length(var.azs)
  vpc_zone_identifier  =[aws_subnet.terraform_public_subnet[count.index].id]
  health_check_type    = "EC2"
  #instance_monitoring=false
  #count=length(var.azs)
#  availability_zones = [var.azs[count.index]] 
  #availability_zones=element(var.azs,count.index)

#slice(var.azs,0,length(var.azs))element(var.azs,count.index)
  
  tag {
      key                 = "Name"
      value               = "autoscaling-instance"
      propagate_at_launch = true
    }
  
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  count=length(aws_autoscaling_group.terraform)
  name                   = "scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.terraform[count.index].name
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  count=length(aws_autoscaling_group.terraform)
  name                   = "scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.terraform[count.index].name
}


