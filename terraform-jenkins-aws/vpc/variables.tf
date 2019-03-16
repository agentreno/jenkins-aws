# Name tag for VPC
variable "vpc_name" {
    type = "string"
    default = "jenkins"
}

# CIDR block for VPC
variable "cidr_block" {
    type = "string"
    default = "10.0.0.0/16"
}

# CIDR block for public subnet
variable "cidr_public_subnet" {
    type = "string"
    default = "10.0.1.0/24"
}

# CIDR block for public secondary subnet
variable "cidr_public_subnet_secondary" {
    type = "string"
    default = "10.0.2.0/24"
}
