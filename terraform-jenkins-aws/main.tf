module "vpc" {
    source = "vpc"
}

module "loadbalancer" {
    source = "loadbalancer"
    # Defined in customers.tf
    jenkins_masters = "${local.jenkins_masters}"
    jenkins_masters_count = "${local.jenkins_masters_count}"

    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.public_subnet_id}"
    subnet_id_secondary = "${module.vpc.public_subnet_secondary_id}"
    domain_name = "${var.domain_name}"
    source_ips_master_http = "${var.source_ips_master}"
}

output "jenkins_url" {
    value = "https://${module.loadbalancer.alb_dns}"
}
