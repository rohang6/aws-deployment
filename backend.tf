terraform {
  backend "s3" {
    bucket = "tf-state-file-storage-23092025"
    key = "aws-deployment/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}