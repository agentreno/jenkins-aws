# Region (for subnet AZs)
variable "region" {
    type = "string"
}

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

# CIDR blocks for public subnets
variable "cidr_public_subnet1" {
    type = "string"
    default = "10.0.1.0/24"
}

variable "cidr_public_subnet2" {
    type = "string"
    default = "10.0.2.0/24"
}

# Name prepend for tagged resources
variable "name_tag_prepend" {
    default = "default_"
}

# External source IPs allowed to access the ALB
variable "external_source_ips" {
    type = "list"
    default = []
}
