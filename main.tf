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

# EC2 Instance 
resource "aws_instance" "demo_ec2" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"

  tags = {
    Name = "DemoEC2"
  }

}