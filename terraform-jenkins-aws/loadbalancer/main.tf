# Load Balancer Resources (LB, listener, target group, security group)
resource "aws_lb" "main" {
    name = "main-jenkins"
    internal = false
    load_balancer_type = "application"
    security_groups = ["${aws_security_group.alb_sg.id}"]
    subnets = ["${var.subnet_id}", "${var.subnet_id_secondary}"]
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = "${aws_lb.main.arn}"
    port = "443"
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = "${aws_acm_certificate_validation.cert.certificate_arn}"

    default_action {
        type = "forward"
        target_group_arn = "${aws_lb_target_group.jenkins_master.arn}"
    }
}

resource "aws_lb_target_group" "jenkins_master" {
    name = "main-jenkins-master-tg"
    port = 8080
    protocol = "HTTP"
    vpc_id = "${var.vpc_id}"

    health_check {
        interval = 5
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 3
        path = "/login"
    }
}

resource "aws_lb_target_group_attachment" "jenkins_master" {
    target_group_arn = "${aws_lb_target_group.jenkins_master.arn}"
    target_id = "${var.jenkins_master_instance_id}"
    port = 8080
}

resource "aws_security_group" "alb_sg" {
    name = "main-jenkins-alb-sg"
    description = "Allow HTTP 443 to Jenkins ALB"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = "${var.source_ips_master_http}"
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Certificate resources
resource "aws_acm_certificate" "cert" {
    domain_name = "jenkins.${var.domain_name}"
    validation_method = "DNS"
}

data "aws_route53_zone" "zone" {
    name = "${var.domain_name}."
    private_zone = false
}

resource "aws_route53_record" "cert_validation" {
    name = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
    type = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
    zone_id = "${data.aws_route53_zone.zone.id}"
    records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
    ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
    certificate_arn = "${aws_acm_certificate.cert.arn}"
    validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

resource "aws_route53_record" "jenkins_cname" {
    zone_id = "${data.aws_route53_zone.zone.id}"
    name = "jenkins"
    type = "CNAME"
    ttl = 60
    records = ["${aws_lb.main.dns_name}"]
}

output "alb_sg" {
    value = "${aws_security_group.alb_sg.id}"
}

output "alb_dns" {
    value = "${aws_route53_record.jenkins_cname.fqdn}"
}
