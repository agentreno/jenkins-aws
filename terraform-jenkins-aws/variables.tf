# Region to use for all resources
variable "region" {
    type = "string"
    default = "eu-west-1"
}

# Pre-existing EC2 key pair to be used for access to instances
variable "ec2_key_pair_name" {
    type = "string"
    default = "karl-devbox"
}
