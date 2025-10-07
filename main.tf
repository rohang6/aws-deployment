module "vpc" {
    source = "./modules/vpc"
}

module "rds" {
    source ="./modules/rds"
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.private_subnet[*]
    ec2_sg_id = module.ec2.ec2_sg_id
}

module "ec2" {
    source = "./modules/ec2"
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.public_subnet[0]
    db_secret_arn = module.rds.db_secret_arn
}
