# The VPC for instance security groups
variable "vpc_id" {}

# The subnet for the ALB
variable "subnet_id" {}

# The subnet for the ALB
variable "subnet_id_secondary" {}

# IP address to restrict inbound access to ALB
variable "source_ips_master_http" {
    type = "list"
}

# The domain name to create a certificate for TLS termination on the ALB
variable "domain_name" {}

# A map of per-customer Jenkins masters (name : master_instance_id)
variable "jenkins_masters" {
    type = "map"
}

# The number of Jenkins masters in var.jenkins_masters
variable "jenkins_masters_count" {}
