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

resource "aws_ecr_repository" "ecr_repo" {
    name = "myapp"
}

resource "aws_iam_role" "ec2_role"{
    name = "ec2_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ssm" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "inline_policy"{
    name = "ECR-ACCESS"
    role = aws_iam_role.ec2_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchGetImage",
                    "ecr:GetDownloadUrlForLayer",
                    "secretsmanager:GetSecretValue"
                ]
                Effect   = "Allow"
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_instance_profile" "ec2_access" {
    name = "ec2_access"
    role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "ubuntu" {
    ami = var.ami_id
    instance_type = "t2.micro"
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    iam_instance_profile = aws_iam_instance_profile.ec2_access.name
    tags = {
        Name = "myapp"
    }
    user_data = <<-EOF
            #!/bin/bash
            sudo apt update 
            sudo apt upgrade -y
            sudo apt install unzip 

            export DB_ARN=${var.db_secret_arn}

            # installing awscli 
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip awscliv2.zip
            sudo ./aws/install

            # Installing Docker
            sudo apt install docker.io -y

            sudo systemctl start docker
            usermod -aG docker ubuntu

            aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr_repo.repository_url}
            docker run -d -p 8080:5000 -e DB_SECRET_ARN=$DB_ARN ${aws_ecr_repository.ecr_repo.repository_url}:latest
        EOF
}