resource "aws_security_group" "ec2_sg" {
    name = "ec2_sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ecr_repository" "ecr_repo" {
    name = "myapp"
}

resource "aws_instance" "web" {
    ami = var.ami_id
    instance_type = "t2.micro"
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    iam_instance_profile = "EC2-SSM"
    user_data = <<-EOF
            #!/bin/bash
            sudo apt update 
            sudo apt upgrade -y

            # Installing Docker
            sudo apt install docker.io -y

            sudo systemctl start docker
            usermod -aG docker ubuntu

            $(aws ecr get-login --no-include-email --region ap-south-1)
            docker run -d -p 8080:5000 ${data.aws_ecr_repository.ecr_repo.repository_url}:latest
        EOF
}