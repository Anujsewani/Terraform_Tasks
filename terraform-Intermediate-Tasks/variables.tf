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



#04-03-2024

variable "public_subnet_cidr"{
  type = list(string)
  description="public subnet cidr block"
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnet_cidr"{
  type =list(string)
  description = "private subnet cidr block"
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "azs" {
  type=list(string)
  description= "Availability zones"
  default=["ap-southeast-1a", "ap-southeast-1b"]
}

#variable "max_connection"{
#  type=string
#  default="1000"
#}

variable "engine"{
  type = object({
    name = string
    version = string
  })

  default = {
    name="mysql"
    version="5.7"
  }
}

variable "instance_class"{
  default="db.t2.micro"
}
variable "storage" {
  type = object({
    allocated_storage = number
    storage_type      = string
  })

  default = {
    allocated_storage = 20
    storage_type      = "gp2"
  }
}


variable "dbusername"{
  default="anuj"
}
variable "dbpassword"{
  default="anuj123456"
}

variable "instances_to_detach"{
  type=set(string)
  default=["i-0cc2503a0f326f541","i-091fe3ed2974d2e24"]
}
