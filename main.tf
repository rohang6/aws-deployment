provider "aws" {
  region = "ap-south-1"
}

# s3 Bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "my-terraform-demo-bucket-916334832814"

  tags = {
    Environment = "Dev"
    Project     = "DemoPipeline"
  }
}

resource "aws_security_group" "allow_web" {
  name = "allow_web"
  description = "Allow web traffic"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_web_ipv4" {
  security_group_id = aws_security_group.allow_web.id
  description = "Allow SSH from web"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_web.id
  description = "Allow Http inbound access"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.allow_web.id
  description = "Allow Outbound Traffic"
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

# EC2 Instance 
resource "aws_instance" "demo_ec2" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.allow_web.id]

  user_data = <<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt upgrade
        sudo apt install -y apache2
        sudo systemctl start apache2
        sudo systemctl enable apache2
        echo "<h1>Hello from Terraform</h1>" > /var/www/html/index.html
        EOF

  tags = {
    Name = "TerraformServer"
  }

}