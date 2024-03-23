resource "aws_vpc" "my_vpc"{
  cidr_block="10.0.0.0/16"
  tags={
    Name="My VPC"
  }
}

resource "aws_internet_gateway" "my_teraform_gateway"{
  vpc_id=aws_vpc.my_vpc.id
  depends_on=[aws_vpc.my_vpc]
  tags={
    Name="Terraform IG"
  }
}


