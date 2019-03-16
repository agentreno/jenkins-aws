# The VPC for instance security groups
variable "vpc_id" {}

# The subnet for the ALB
variable "subnet_id" {}

# The subnet for the ALB
variable "subnet_id_secondary" {}

# The instance ID of the Jenkins master to target
variable "jenkins_master_instance_id" {}

# IP address to restrict inbound access to ALB
variable "source_ips_master_http" {
    type = "list"
}

# The domain name to create a certificate for TLS termination on the ALB
variable "domain_name" {}
