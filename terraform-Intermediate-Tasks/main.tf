provider "aws"{
  region="ap-southeast-1"
}


resource "aws_security_group" "SG1"{
  name=var.instance_sg

  ingress{
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }

  ingress{
    from_port=22
    to_port=22
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }



  egress{
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }


}

resource "aws_key_pair" "terraform_key"{
  key_name= var.instance_key
  public_key=file("${abspath(path.cwd)}/terraform_key.pub")
}



resource "aws_instance" "terraform_launched" {
  ami = var.instance_ami
  instance_type = var.instance_type
  count=1
  key_name= aws_key_pair.terraform_key.key_name
  security_groups=[aws_security_group.SG1.name] 
  iam_instance_profile=aws_iam_instance_profile.terraform_iam_instance_profile.name
  tags = {
    Name = var.instance_name
  }
}


resource "aws_s3_bucket" "terraform_s3bukcet"{
  bucket=var.instance_s3bucket
  acl    = "private" 
  tags = {
    Name = "Terraform_s3_bucket"
  }
}



resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="Terraform VPC"
  }
}

resource "aws_subnet" "terraform-public_subnet"{
  count=length(var.public_subnet_cidr)
  vpc_id=aws_vpc.terraform_vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone=element(var.azs,count.index)
  tags = {
    Name = "terraform public subnet ${count.index +1}"
  }
}


resource "aws_subnet" "terraform_private_subnet"{
  count=length(var.private_subnet_cidr)
  vpc_id=aws_vpc.terraform_vpc.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone=element(var.azs,count.index)

  tags = {
    Name = "terraform private subnet ${count.index +1}"
  }
}

resource "aws_internet_gateway" "terraform_gateway"{
  vpc_id=aws_vpc.terraform_vpc.id
  tags = {
    Name="Terraform VPC IG"
  }
}

resource "aws_route_table" "terraform_route_table"{
  vpc_id=aws_vpc.terraform_vpc.id
  route{
    cidr_block="0.0.0.0/0"
    gateway_id=aws_internet_gateway.terraform_gateway.id
  }
  tags = {
    Name="2nd Route Table for Terraform"
  }
}


resource "aws_route_table_association" "terraform_route_table_association"{
  count=length(var.public_subnet_cidr)
  subnet_id=element(aws_subnet.terraform-public_subnet[*].id, count.index)
  route_table_id=aws_route_table.terraform_route_table.id
}

resource "aws_iam_role" "terraform_role"{
  name="Terraform-Role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_policy"{
  name="Terraform-Policy"
  description="Policy for terraform ec2 instance"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "autoscaling:DetachIntances"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_role_policy_attachment"{
  role=aws_iam_role.terraform_role.name
  policy_arn=aws_iam_policy.terraform_policy.arn
}

resource "aws_iam_instance_profile" "terraform_iam_instance_profile" {
  name = "Terraform-Role"
  role = aws_iam_role.terraform_role.name
}



resource "aws_launch_configuration" "terraform_launch_config"{
  name= "Terraform-launch-config"
  image_id="ami-07a6e3b1c102cdba8"
  instance_type="t2.micro"
}

resource "aws_autoscaling_group" "terraform_autoscaling_group"{
  name="Terraform-ASG"
  launch_configuration=aws_launch_configuration.terraform_launch_config.name
  min_size=1
  max_size=6
  desired_capacity=4
  availability_zones=["ap-southeast-1a"]
  health_check_type="ELB"
  health_check_grace_period=120
  #health_check_healthy_threshold=1
  #health_check_unhealthy_threshold=1
}






resource "aws_db_parameter_group" "terraform_db_parameter_group"{
  name="terraform-db-parameter-group"
  family="mysql5.7"
  description="terraform parameter group for mysql 5.7"
  parameter{
    name="max_connections"
    value="1000"
  }
}
resource "aws_security_group" "rds_db_security_group" {
  name        = "rds-db-security-group"
  description = "RDS security group for RDS"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from any IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "terraform_rds_instance"{
  engine=var.engine.name
  engine_version=var.engine.version
  instance_class=var.instance_class
  allocated_storage=var.storage.allocated_storage
  storage_type=var.storage.storage_type

  username=var.dbusername
  password=var.dbpassword
  parameter_group_name=aws_db_parameter_group.terraform_db_parameter_group.name
  vpc_security_group_ids=[aws_security_group.rds_db_security_group.id]
}


resource "aws_autoscaling_policy""detach_instances"{
  name="detach_instances"
  scaling_adjustment=-2
  adjustment_type="ChangeInCapacity"
  autoscaling_group_name="Terraform-ASG"
  
}

