 resource "aws_s3_bucket" "S3"{
  bucket=var.s3bucket
   tags={
    Name= "My S3 Bucket"
  }
}
