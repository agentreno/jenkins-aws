# The subnet to launch the Jenkins EC2 instances into
variable "subnet_id" {}

# The key pair to use for SSH access to Jenkins EC2 instances
variable "ec2_key_pair_name" {}

# Name prepend for tagged resources
variable "name_tag_prepend" {
    default = "default"
}

# Instance types
variable "master_instance_type" {
    default = "t2.micro"
}

variable "slave_instance_type" {
    default = "t2.micro"
}
