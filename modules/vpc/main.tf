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

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.aws_deployment.id
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.aws_deployment.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

# resource "aws_route_table_association" "public" {
#     subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
#     route_table_id = aws_route_table.public_rt.id
# }