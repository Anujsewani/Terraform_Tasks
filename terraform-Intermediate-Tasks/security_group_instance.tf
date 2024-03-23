resource "aws_security_group" "isntance_sg"{
  name=var.sg1
  vpc_id=aws_vpc.my_vpc.id
  depends_on=[aws_vpc.my_vpc]
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

