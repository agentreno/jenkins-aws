module "vpc" {
    source = "vpc"
}

module "jenkins" {
    source = "jenkins"
    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.public_subnet_id}"
    ec2_key_pair_name = "${var.ec2_key_pair_name}"
    source_ips_master_http = "${var.source_ips_master}"
    source_ips_master_ssh = "${var.source_ips_master}"
}

output "jenkins_url" {
    value = "${module.jenkins.master_url}"
}

output "jenkins_slave_ip" {
    value = "${module.jenkins.slave_ip}"
}
