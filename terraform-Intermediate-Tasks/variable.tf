variable "azs"{
  type=list(string)
  description= "Availability zones"
  default=["ap-southeast-1a","ap-southeast-1b"]
}
variable "public_subnet_cidr"{
  type=list(string)
  description= "public subnets"
  default=["10.0.0.0/28","10.0.0.16/28"]
}
variable "instance_key" {
  default= "terraform_key"
}

variable "instance_ami"{
  type=string
  description="ami id of instance"
  default="ami-06c4be2792f419b7b"
}
variable "type"{
  default="t2.micro"
}

variable "sg1"{
  default="instance_SG"
}

variable "s3bucket"{
  type=string
  default="anuj-s3bucket"
}

variable "regions"{
  type=string
  default="ap-southeast-1"
}

variable "iamrole"{
  type=string
  default="Terraform-s3-role"
}
variable "iampolicy"{
  type=string
  default="Terraform-Policy"
}

variable "policyattach"{
  type=string
  default="policy-attach-iam-role"
}

variable "instanceprofile"{
  type=string
  default="policy-instance"
}


variable "desired_capacity"{
  default=1
}

variable "min_capacity"{
  default=1
}

variable "max_capacity"{
  default=3
}

#variable "subnet_ids" {
#  description = "List of subnet IDs across multiple AZs"
#  type        = list(string)
#  defaut=
#}
variable "asg"{
  type=string
  default="ASG-config"
}

