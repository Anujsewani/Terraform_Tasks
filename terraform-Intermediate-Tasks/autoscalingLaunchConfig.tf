resource "aws_launch_configuration" "autoscale_config"{
  name=var.asg
  image_id=var.instance_ami
  instance_type=var.type
  key_name=aws_key_pair.terraform_key.key_name
 
  security_groups=[aws_security_group.isntance_sg.id]
  depends_on=[aws_vpc.my_vpc, aws_security_group.isntance_sg,aws_key_pair.terraform_key]
  lifecycle {
    create_before_destroy = true
  }
}

