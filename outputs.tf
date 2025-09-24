output "s3_bucket_name" {
    description = "S3 bucket name"
    value = aws_s3_bucket.demo_bucket.bucket
}

output "ec2_public_ip" {
    description = "server public ip"
    value = aws_instance.demo_ec2.public_ip
}

output "webserver_url"{
    description = "Link for the server"
    value = "http://${aws_instance.demo_ec2.public_ip}"
}