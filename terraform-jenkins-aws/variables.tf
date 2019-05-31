# Region to use for all resources
variable "region" {
    type = "string"
    default = "eu-west-1"
}

# AWS Profile in credentials file to use
variable "profile" {
    type = "string"
    default = "default"
}

# Pre-existing EC2 key pair to be used for access to instances
variable "ec2_key_pair_name" {
    type = "string"
    default = "karl-devbox"
}

variable "ec2_key_pair_private_path" {
    type = "string"
}

# Source IP ranges allowed to access the ALB
variable "source_ips" {
    type = "list"
    default = []
}
