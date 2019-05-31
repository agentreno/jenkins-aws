# The VPC for instance security groups
variable "vpc_id" {}

# Security groups to apply to the ALB
variable "alb_security_groups" {
    type = "list"
    default = []
}

# Subnet IDs to launch ALB into (needs 2 separate AZs)
variable "subnet_ids" {
    type = "list"
    default = []
}

# Name prepend for tagged resources
variable "name_tag_prepend" {
    default = "default-"
}

