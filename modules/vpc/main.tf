data "aws_availability_zones" "available" {

}

resource "aws_vpc" "aws_deployment" {
    cidr_block = var.cidr_block
}

resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.aws_deployment.id
    cidr_block = var.public_subnets[count.index]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.aws_deployment.id
    cidr_block = var.private_subnets[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
}