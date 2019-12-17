provider "aws" {
    access_key	= "${var.aws_access_key}"
    secret_key	= "${var.aws_secret_key}"
    region	= "${var.aws_region}"
}

resource "aws_launch_configuration" "aws-ec2-as-webserver-lc" {
    name_prefix     = "aws-ec2-as-webserver-lc-"
    image_id        = "${var.ami}"
    instance_type   = "t2.nano"
    key_name        = "${var.key_name}"
    security_groups = ["${aws_security_group.aws-ec2-as-webserver-instance-sg.id}"]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_lb_target_group" "aws-ec2-as-webserver-tg" {
    name        = "aws-ec2-as-webserver-tg"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${var.vpc_id}"
}

resource "aws_autoscaling_group" "aws-ec2-as-webserver-asg" {
    name                 = "aws-ec2-as-webserver-asg"
    launch_configuration = "${aws_launch_configuration.aws-ec2-as-webserver-lc.name}"
    min_size             = 2
    max_size             = 4
    health_check_type    = "ELB"
    vpc_zone_identifier  = ["${var.private_subnet_a_id}", "${var.private_subnet_b_id}"]
    target_group_arns    = ["${aws_lb_target_group.aws-ec2-as-webserver-tg.arn}"]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_policy" "aws-ec2-as-webserver-asg-policy" {
    name                   = "aws-ec2-as-webserver-asg-policy"
    policy_type            = "TargetTrackingScaling"
    autoscaling_group_name = "${aws_autoscaling_group.aws-ec2-as-webserver-asg.name}"

    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }

        target_value = 70.0
    }
}

resource "aws_lb" "aws-ec2-as-webserver-alb" {
    name               = "aws-ec2-as-webserver-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = ["${aws_security_group.aws-ec2-as-webserver-alb-sg.id}"]
    subnets            = ["${var.public_subnet_a_id}", "${var.public_subnet_b_id}"]

    tags = {
        Name = "aws-ec2-as-webserver-alb"
    }
}

resource "aws_lb_listener" "aws-ec2-as-webserver-alb-listener-1" {
    load_balancer_arn = "${aws_lb.aws-ec2-as-webserver-alb.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type = "redirect"

        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

resource "aws_lb_listener" "aws-ec2-as-webserver-alb-listener-2" {
    load_balancer_arn = "${aws_lb.aws-ec2-as-webserver-alb.arn}"
    port              = "443"                                            
    protocol          = "HTTPS"
    certificate_arn   = "${var.ssl_certificate_arn}"
                                                                           
    default_action {                                                       
        type             = "forward"                                       
        target_group_arn = "${aws_lb_target_group.aws-ec2-as-webserver-tg.arn}"   
    }                                                                      
}                                                                          


output "aws-ec2-as-webserver-alb" {
    value = "${aws_lb.aws-ec2-as-webserver-alb.dns_name}"
}

