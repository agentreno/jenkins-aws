resource "aws_lb" "default" {
    name = "${var.name_tag_prepend}jenkins-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = ["${var.alb_security_groups}"]
    subnets = ["${var.subnet_ids}"]
}
