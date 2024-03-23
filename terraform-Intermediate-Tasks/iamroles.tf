resource "aws_iam_role" "terraform_role"{
  name=var.iamrole
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "s3.amazonaws.com"
                ]
            }
        }
    ]
  })
}


resource "aws_iam_policy" "terraform_policy"{
  name=var.iampolicy
  description="Policy for terraform ec2 instance"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        },
        {

            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        }
    ]
})
}


resource "aws_iam_policy_attachment" "policy_attach_to_role"{
  name=var.policyattach
  roles=[aws_iam_role.terraform_role.name]
  policy_arn=aws_iam_policy.terraform_policy.arn
  depends_on=[aws_iam_role.terraform_role,aws_iam_policy.terraform_policy]
}

resource "aws_iam_instance_profile" "terraform_iam_instance_profile"{
  name=var.instanceprofile
  role=aws_iam_role.terraform_role.name
  depends_on=[aws_iam_role.terraform_role]
}

