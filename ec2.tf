//module "my_vpc" {
//  source = "terraform-aws-modules/vpc/aws"
//
//  name = "my-vpc"
//  cidr = "10.0.0.0/16"
//
//  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
//  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
//  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
//
//  enable_nat_gateway = true
//  enable_vpn_gateway = true
//
//  tags = {
//    Terraform = "true"
//    Environment = "dev"
//  }
//}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0069d66985b09d219" # eu-west-1
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
//subnet_id         = module.my_vpc.public_subnets[0] # ok
//availability_zone = module.my_vpc.azs[0] # ok
  subnet_id         = "subnet-03ba8b36bcfafd02f"
  availability_zone = "eu-west-1a"
  key_name        = aws_key_pair.my_pub_key.key_name
  user_data = file("./startup.sh")
  iam_instance_profile = "${aws_iam_instance_profile.my_ec2_profile.name}"
  tags = {
    Name: "my-ec2"
  }
}

data "local_file" "my_pub_key" {
  filename = "/Users/lucasko/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "my_pub_key" {
  key_name   = "deployer-key"
  //public_key = "ssh-rsa xxxxx"
  public_key = data.local_file.my_pub_key.content
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  #vpc_id     = module.my_vpc.vpc_id
  vpc_id      =  "vpc-0d67f617542426bba"

  ingress {
    description      = "SSL to EC2"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["106.1.233.151/32"]
  }
  ingress {
    description      = "OpenVPN Server "
    from_port        = 1194
    to_port          = 1194
    protocol         = "tcp"
    cidr_blocks = ["106.1.233.151/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

output "ip" {
  description = "ec2 ip"
  value       = aws_instance.my_ec2.public_ip
}

//resource "tls_private_key" "my_ssh" {
//  algorithm = "RSA"
//  rsa_bits  = 4096
//}
//resource "local_file" "my_ssh_key" {
//  filename = pathexpand("~/.ssh/id_rsa.pub")
//  file_permission = "600"
//  directory_permission = "700"
//  sensitive_content = tls_private_key.my_ssh.public_key_openssh
//}
//resource "aws_key_pair" "generated_key" {
//  key_name   = "lucasko_pub_key"
//  public_key = local_file.my_ssh_key
//}


resource "aws_iam_instance_profile" "my_ec2_profile" {
  name = "my_ec2_profile"
  role = aws_iam_role.my_ec2_iam_role.name
}

resource "aws_iam_role" "my_ec2_iam_role" {
  name = "my_ec2_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "my_ec2_role_policy" {
  name = "web_iam_role_policy"
  role = "${aws_iam_role.my_ec2_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": [
              "s3:Get*",
              "s3:List*",
              "s3:PutObject",
              "s3:DeleteObject",
              "s3:DeleteObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::lucasko-cicd-bucket/*"
            ]
     },
    {
        "Effect": "Allow",
        "Action": [
          "s3:List*"
        ],
        "Resource": [
            "arn:aws:s3:::*"
        ]
    }
  ]
}
EOF
}