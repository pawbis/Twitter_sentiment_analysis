resource "aws_instance" "test_machine" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.test_generated_key.key_name
  iam_instance_profile = "${aws_iam_instance_profile.test_instance_profile.id}"

  network_interface {
    network_interface_id = aws_network_interface.test_interface_1.id
    device_index = 0
  }

  tags = {
    Name = "TEST EC2 INSTANCE"
    Description = "TESTING TERRAFORM BY PROVISIONING THIS MACHINE"
  }
  user_data = <<EOF
  sudo apt update
  EOF
}

resource "aws_iam_role" "test_role" {
  name = "TEST_ROLE"
  assume_role_policy = <<EOF
 {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "test_instance_profile" {
  name = "TEST_INSTANCE_PROFILE"
  role = aws_iam_role.test_role.name
}

resource "aws_iam_role_policy" "test_policy" {
  name = "TEST_IAM_ROLE_POLICY"
  role = "${aws_iam_role.test_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::TEST_BUCKET"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::TEST_BUCKET/*"]
    }
  ]
}
EOF
}


resource "tls_private_key" "test_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "test_generated_key" {
  key_name = "TEST_SSH_KEY"
  public_key = tls_private_key.test_key.public_key_openssh
}

resource "aws_vpc" "test_vpc"{
    cidr_block = "172.16.0.0/16"

    tags = {
        name = "TEST_VPC"
    }
}

resource "aws_subnet" "test_subnet" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "172.16.10.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        name = "TEST_SUBNET"
    }
}

resource "aws_network_interface" "test_interface_1"{
    subnet_id = aws_subnet.test_subnet.id
    private_ips = ["172.16.10.100"]

    tags = {
        name = "TEST_INTERFACE 1"
    }
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "wiadro-do-testow"
  tags = {
    Name = "TEST_BUCKET_FOR_EC2"
  }
}

resource "aws_s3_bucket_acl" "test_acl" {
  bucket = aws_s3_bucket.test_bucket.id
  acl = "private"
}