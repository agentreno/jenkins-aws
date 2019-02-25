module "vpc" {
	source = "vpc"
}

module "jenkins" {
	source = "jenkins"
	subnet_id = "${module.vpc.public_subnet_id}"
	ec2_key_pair_name = "${var.ec2_key_pair_name}"
}

output "jenkins_url" {
	value = "${module.jenkins.master_url}"
}
