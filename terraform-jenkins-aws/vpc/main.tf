data "aws_availability_zones" "available" {}

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

resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_public_subnet}"
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags {
        Name = "${var.vpc_name}_public_subnet"
    }
}

resource "aws_subnet" "public_subnet_secondary" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.cidr_public_subnet_secondary}"
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availability_zones.available.names[1]}"

    tags {
        Name = "${var.vpc_name}_public_subnet_secondary"
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

resource "aws_route_table_association" "public_routes_association" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.public_routes.id}"
}

output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

output "public_subnet_id" {
    value = "${aws_subnet.public_subnet.id}"
}

output "public_subnet_secondary_id" {
    value = "${aws_subnet.public_subnet_secondary.id}"
}
