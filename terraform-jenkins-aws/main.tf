module "vpc" {
    source = "vpc"
    region = "${var.region}"
    external_source_ips = "${var.source_ips}"
}

module "jenkins" {
    source = "jenkins"
    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${element(module.vpc.public_subnet_ids, 0)}"
    ec2_key_pair_name = "${var.ec2_key_pair_name}"
    ec2_key_pair_private_path = "${var.ec2_key_pair_private_path}"
    slave_security_groups = ["${module.vpc.master_slave_sg_id}"]
    master_security_groups = ["${module.vpc.alb_master_sg_id}", "${module.vpc.master_slave_sg_id}"]
}

module "loadbalancer" {
    source = "loadbalancer"
    vpc_id = "${module.vpc.vpc_id}"
    subnet_ids = ["${module.vpc.public_subnet_ids}"]
    alb_security_groups = ["${module.vpc.alb_master_sg_id}", "${module.vpc.external_alb_sg_id}"]
}

output "jenkins_url" {
    value = "${module.jenkins.master_url}"
}

output "jenkins_slave_ip" {
    value = "${module.jenkins.slave_ip}"
}
