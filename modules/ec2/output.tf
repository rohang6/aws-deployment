output "public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "ec2_sg_id" {
    value = aws_security_group.ec2_sg.id
}