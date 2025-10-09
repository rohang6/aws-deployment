output "public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "ec2_sg_id" {
    value = aws_security_group.ec2_sg.id
}

output "ecr_repo_url" {
    value = aws_ecr_repository.ecr_repo.repository_url
}