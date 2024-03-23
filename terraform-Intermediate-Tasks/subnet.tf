#resource "aws_subnet" "terraform_public_subnet"{
#  cidr_block="10.0.0.0/28"
#  vpc_id=aws_vpc.my_vpc.id
#  availability_zone=var.azs
#  depends_on=[aws_vpc.my_vpc]
#  tags={
#    Name="Terraform Public Subnet"
#  }
#}

resource "aws_subnet" "terraform_public_subnet"{
  count=length(var.public_subnet_cidr)
  #count1=length(var.azs)
  vpc_id=aws_vpc.my_vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone=element(var.azs,count.index)
  
  tags = {
    Name = "terraform public subnet ${count.index +1}"
  }
}


