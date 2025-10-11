resource "random_password" "db_password" {
    length = 16
    special = true
    override_special = "!#$%^&*()_+-=[]{}|:,.<>?"  # safe special chars
}

resource "aws_security_group" "rds_sg" {
    name = "rds_sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [var.ec2_sg_id]
    }
}

resource "aws_db_subnet_group" "db_subnet" {
    name = "db_subnet"
    subnet_ids = var.subnets
}

resource "aws_db_instance" "mydb" {
    allocated_storage = 20
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    username = "admin"
    password = random_password.db_password.result
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    db_subnet_group_name = aws_db_subnet_group.db_subnet.name
    skip_final_snapshot = true
}

resource "null_resource" "create_database" {
    depends_on = [ aws_db_instance.mydb ]

    provisioner "local-exec" {
        command = <<EOF
            mysql -u ${aws_db_instance.mydb.endpoint} -P 3306 -u admin -p${random_password.db_password.result} -e "CREATE DATABASE database;"
        EOF

        environment = {
            MYSQL_PWD = random_password.db_password.result
        }     
    }
}

resource "aws_secretsmanager_secret" "db_secret"{
    name = "mydb_secret_12"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
    secret_id = aws_secretsmanager_secret.db_secret.id
    secret_string = jsonencode({
        username = "admin"
        password = random_password.db_password.result
        host = aws_db_instance.mydb.endpoint
        database = "database"
    })
}

