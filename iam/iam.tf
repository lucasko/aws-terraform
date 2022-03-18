//module "iam_account" {
//  source  = "terraform-aws-modules/iam/aws//modules/iam-account"
//  version = "~> 4"
//  account_alias = "lucasko"
//  minimum_password_length = 8
//  require_numbers         = false
//}

module "iam" {
  source  = "terraform-aws-modules/iam/aws"
  version = "4.14.0"
}

resource "aws_iam_user" "lucasko" {
  name = "lucasko"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_user_policy" "lucasko" {
  name = "lucasko_dev"
  user = aws_iam_user.lucasko.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
//resource "aws_iam_access_key" "lucasko" {
//  user = aws_iam_user.lucasko.name
//}
//
//output "secret" {
//  sensitive = true
//  description = "The secret for logging in to aws cli"
//  value = aws_iam_access_key.lucasko.secret
//}

