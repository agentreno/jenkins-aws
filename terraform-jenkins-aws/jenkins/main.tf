# Data inputs
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

# Jenkins master and slave instances
resource "aws_instance" "jenkins_master" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.master_instance_type}"
    subnet_id = "${var.subnet_id}"

    key_name = "${var.ec2_key_pair_name}"

    tags {
        Name = "${var.name_tag_prepend}_jenkins_master"
    }
}

resource "aws_instance" "jenkins_slave" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.slave_instance_type}"
    subnet_id = "${var.subnet_id}"

    key_name = "${var.ec2_key_pair_name}"

    tags {
        Name = "${var.name_tag_prepend}_jenkins_slave"
    }
}

resource "aws_security_group" "jenkins_master_sg" {
    name = "${var.name_tag_prepend}_jenkins_master_sg"
    description = "Allow HTTP 8080 and SSH to Jenkins master"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "-1"
        cidr_blocks = "${var.source_ips_master_http}"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "-1"
        cidr_blocks = "${var.source_ips_master_ssh}"
    }
}

output "master_url" {
    value = "http://${aws_instance.jenkins_master.public_ip}:8080"
}
