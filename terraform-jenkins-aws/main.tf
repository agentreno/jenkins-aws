module "vpc" {
    source = "vpc"
}

module "loadbalancer" {
    source = "loadbalancer"
    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.public_subnet_id}"
    subnet_id_secondary = "${module.vpc.public_subnet_secondary_id}"
    jenkins_master_instance_id = "${module.jenkins.master_instance_id}"
    domain_name = "${var.domain_name}"
    source_ips_master_http = "${var.source_ips_master}"
}

module "jenkins" {
    source = "jenkins"
    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.public_subnet_id}"
    ec2_key_pair_name = "${var.ec2_key_pair_name}"
    ec2_key_pair_private_path = "${var.ec2_key_pair_private_path}"
    source_ips_master_http = "${var.source_ips_master}"
    source_ips_master_ssh = "${var.source_ips_master}"
    alb_sg = "${module.loadbalancer.alb_sg}"
}

output "jenkins_url" {
    value = "https://${module.loadbalancer.alb_dns}"
}

output "jenkins_slave_ip" {
    value = "${module.jenkins.slave_ip}"
}
