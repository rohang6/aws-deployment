variable "cidr_block" {
    description = "VPC cidr range"
    type = string
    default = "10.10.0.0/24"
}
variable "public_subnets" {
    description = "Public subnet"
    type = list(string)
    default = ["10.10.0.0/26"]
}

variable "private_subnets" {
    description = "Private Subnet"
    type = list(string)
    default = ["10.10.0.64/26"]
}
