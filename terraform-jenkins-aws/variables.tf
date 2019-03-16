# Region to use for all resources
variable "region" {
    type = "string"
    default = "eu-west-1"
}

# Pre-existing EC2 key pair to be used for access to instances
variable "ec2_key_pair_name" {}

# Path to private part of key, this is used to give master SSH access to slave
variable "ec2_key_pair_private_path" {}

# Source IP ranges to allow HTTP and SSH to master
variable "source_ips_master" {
    type = "list"
}

# Existing route 53 domain to create a jenkins subdomain and cert
variable "domain_name" {}
