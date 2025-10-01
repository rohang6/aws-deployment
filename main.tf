module "vpc" {
    source = "./modules/vpc"
}

module "ec2" {
    source = "./modules/ec2"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.public_subnet[0]
}

module "rds" {
    source ="./modules/rds"
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.private_subnet[0]
    ec2_sg_id = module.ec2.ec2_sg_id
}