resource "aws_instance" "terraform"{
  ami=var.instance_ami
  instance_type=var.type
  key_name=aws_key_pair.terraform_key.key_name
  count=length(var.azs)
  availability_zone=var.azs[count.index]
  associate_public_ip_address=false
  subnet_id=aws_subnet.terraform_public_subnet[count.index].id
  vpc_security_group_ids=[aws_security_group.isntance_sg.id]
  #security_groups=[aws_security_group.isntance_sg.name]
  iam_instance_profile=aws_iam_instance_profile.terraform_iam_instance_profile.name
  depends_on=[aws_vpc.my_vpc, aws_security_group.isntance_sg, aws_subnet.terraform_public_subnet, aws_iam_instance_profile.terraform_iam_instance_profile]
  tags={
    Name="Terraform Instance"
  }
}
