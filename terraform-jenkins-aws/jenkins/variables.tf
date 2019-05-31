# The VPC for instance security groups
variable "vpc_id" {}

# The subnet to launch the Jenkins EC2 instances into
variable "subnet_id" {}

# The key pair to use for SSH access to Jenkins EC2 instances
variable "ec2_key_pair_name" {}

# The path to the private key to allow Jenkins master access to slave
variable "ec2_key_pair_private_path" {}

# Security groups
variable "slave_security_groups" {
    type = "list"
    default = []
}

variable "master_security_groups" {
    type = "list"
    default = []
}

# Name prepend for tagged resources
variable "name_tag_prepend" {
    default = "default_"
}

# Instance types
variable "master_instance_type" {
    default = "t2.micro"
}

variable "slave_instance_type" {
    default = "t2.micro"
}
