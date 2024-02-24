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









###
