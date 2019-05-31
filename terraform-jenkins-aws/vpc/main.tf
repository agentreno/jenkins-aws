# VPC Resources
resource "aws_vpc" "main" {
    cidr_block = "${var.cidr_block}"

    tags {
        Name = "${var.vpc_name}"
    }
    enable_dns_support = true
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_subnet" "public_subnet1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_public_subnet1}"
    map_public_ip_on_launch = true
    availability_zone = "${var.region}a"

    tags {
        Name = "${var.vpc_name}_public_subnet1"
    }
}

resource "aws_subnet" "public_subnet2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_public_subnet2}"
    map_public_ip_on_launch = true
    availability_zone = "${var.region}b"

    tags {
        Name = "${var.vpc_name}_public_subnet2"
    }
}

resource "aws_route_table" "public_routes" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags {
        Name = "${var.vpc_name}_public_routes"
    }
}

resource "aws_route_table_association" "public_routes_association1" {
    subnet_id = "${aws_subnet.public_subnet1.id}"
    route_table_id = "${aws_route_table.public_routes.id}"
}

resource "aws_route_table_association" "public_routes_association2" {
    subnet_id = "${aws_subnet.public_subnet2.id}"
    route_table_id = "${aws_route_table.public_routes.id}"
}

resource "aws_security_group" "master_slave_sg" {
    name = "${var.name_tag_prepend}master_slave_sg"
    description = "Allow comms between Jenkins master and Jenkins slave"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        self = true
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "alb_master_sg" {
    name = "${var.name_tag_prepend}alb_master_sg"
    description = "Allow comms between ALB and Jenkins Master"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        self = true
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "external_alb_sg" {
    name = "${var.name_tag_prepend}external_alb_sg"
    description = "Allow external comms into the ALB"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = "${var.external_source_ips}"
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "master_slave_sg_id" {
    value = "${aws_security_group.master_slave_sg.id}"
}

output "alb_master_sg_id" {
    value = "${aws_security_group.alb_master_sg.id}"
}

output "external_alb_sg_id" {
    value = "${aws_security_group.external_alb_sg.id}"
}

output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "public_subnet_ids" {
    value = ["${aws_subnet.public_subnet1.id}", "${aws_subnet.public_subnet2.id}"]
}
