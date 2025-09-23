output "s3_bucket_name" {
    description = "S3 bucket name"
    value = aws_s3_bucket.demo_bucket
}

output "ec2_public_ip" {
    description = "server public ip"
    value = aws_instance.demo_ec2
}