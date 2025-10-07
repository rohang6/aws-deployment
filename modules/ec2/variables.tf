variable "ami_id" {
    description = "Instance id"
    default = "ami-02d26659fd82cf299"
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "db_secret_arn"{
    type = string
    description = "Secret Manager ARN"
}