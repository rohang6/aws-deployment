#!/bin/bash
sudo apt update 
sudo apt upgrade -y

# Installing Docker
sudo apt install docker.io -y

sudo systemctl start docker
usermod -aG docker ubuntu

$(aws ecr get-login --no-include-email --region ap-south-1)
docker run -d -p 80:5000 ${data.aws_ecr_reporitory.app.repository_url}:latest