# Per-customer Jenkins definitions
# The count must match the number of master entries!
locals {
    jenkins_masters_count = 2
    jenkins_masters = {
        "ciso1" = "${module.ciso1.master_instance_id}"
        "ciso2" = "${module.ciso2.master_instance_id}"
    }
}

# CISO Test 1
module "ciso1" {
    source = "jenkins"
    name_tag_prepend = "ciso1"

    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.public_subnet_id}"
    ec2_key_pair_name = "${var.ec2_key_pair_name}"
    ec2_key_pair_private_path = "${var.ec2_key_pair_private_path}"
    source_ips_master_http = "${var.source_ips_master}"
    source_ips_master_ssh = "${var.source_ips_master}"
    alb_sg = "${module.loadbalancer.alb_sg}"
}

# CISO Test 2
module "ciso2" {
    source = "jenkins"
    name_tag_prepend = "ciso2"

    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.public_subnet_id}"
    ec2_key_pair_name = "${var.ec2_key_pair_name}"
    ec2_key_pair_private_path = "${var.ec2_key_pair_private_path}"
    source_ips_master_http = "${var.source_ips_master}"
    source_ips_master_ssh = "${var.source_ips_master}"
    alb_sg = "${module.loadbalancer.alb_sg}"
}
