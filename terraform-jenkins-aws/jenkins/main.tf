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

data "template_file" "add_node_groovy_script" {
    template = "${file("jenkins/add-node.groovy")}"
    vars {
        slave_ip = "${aws_instance.jenkins_slave.private_ip}"
    }
}

data "template_file" "create_credential_groovy_script" {
    template = "${file("jenkins/create-credential.groovy")}"
    vars {
        private_key_pem_source = "${file("${var.ec2_key_pair_private_path}")}"
    }
}

# Jenkins master and slave instances
resource "aws_instance" "jenkins_master" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.master_instance_type}"
    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = ["${var.master_security_groups}"]

    key_name = "${var.ec2_key_pair_name}"

    user_data = "${file("jenkins/jenkins_master_user_data.sh")}"

    tags {
        Name = "${var.name_tag_prepend}eenkins_master"
    }

    # Provisioning
    connection {
        type = "ssh"
        user = "ubuntu"
    }

    provisioner "file" {
        content = "${data.template_file.create_credential_groovy_script.rendered}"
        destination = "/home/ubuntu/create-credential.groovy"
    }

    provisioner "file" {
        content = "${data.template_file.add_node_groovy_script.rendered}"
        destination = "/home/ubuntu/add-node.groovy"
    }

    provisioner "remote-exec" {
        inline = [
            "cloud-init status --wait",
            "until sudo test -f /var/lib/jenkins/secrets/initialAdminPassword; do sleep 1; done",
            "echo Admin Password:",
            "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
        ]
    }
}

resource "aws_instance" "jenkins_slave" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.slave_instance_type}"
    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = ["${var.slave_security_groups}"]

    key_name = "${var.ec2_key_pair_name}"

    user_data = "${file("jenkins/jenkins_slave_user_data.sh")}"

    tags {
        Name = "${var.name_tag_prepend}jenkins_slave"
    }
}

output "master_url" {
    value = "http://${aws_instance.jenkins_master.public_ip}:8080"
}

output "slave_ip" {
    value = "${aws_instance.jenkins_slave.private_ip}"
}
