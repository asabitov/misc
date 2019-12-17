resource "aws_security_group" "aws-ec2-as-webserver-alb-sg" {
    name        = "aws-ec2-as-webserver-alb-sg"
    description = "aws-ec2-as-webserver-alb-sg"
    vpc_id   = "${var.vpc_id}"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }

    tags = {
        Name = "aws-ec2-as-webserver-alb-sg"
    }
}

resource "aws_security_group" "aws-ec2-as-webserver-instance-sg" {
    name        = "aws-ec2-as-webserver-instance-sg"
    description = "aws-ec2-as-webserver-instance-sg"
    vpc_id   = "${var.vpc_id}"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks     = "${var.bastion_ips}"
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups    = ["${aws_security_group.aws-ec2-as-webserver-alb-sg.id}"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }

    tags = {
        Name = "aws-ec2-as-webserver-instance-sg"
    }
}
