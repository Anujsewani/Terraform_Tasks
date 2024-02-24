variable "instance_type"{
  default="t2.micro"
}

variable "instance_ami" {
  default="ami-0fa377108253bf620"
}

variable "instance_key" {
  default= "terraform_key"
}

variable "instance_name" {
  default="terraformInstance1"
}

variable "instance_sg" {
  default="terraform_SG2"
}

variable "instance_vpc"{
  default="vpc-0bfc24833013a1d8f"
}

variable "instance_s3bucket"{
  default="anuj-terraform-bucket"
}
