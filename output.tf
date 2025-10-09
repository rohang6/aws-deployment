output "public_ip" {
  value = module.ec2.public_ip
}

output "ec2_sg_id" {
    value = module.ec2.ec2_sg_id
}

output "ecr_repo_url" {
    value = module.ec2.ecr_repo_url
}

output "vpc_id" {
    value = module.vpc.vpc_id
}