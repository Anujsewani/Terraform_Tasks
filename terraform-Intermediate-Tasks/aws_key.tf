resource "aws_key_pair" "terraform_key"{
  key_name= var.instance_key
  public_key=file("${abspath(path.cwd)}/terraform_key.pub")
}

