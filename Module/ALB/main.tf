# create an application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# create a target group
resource "aws_lb_target_group" "tg" {
  name        = "${var.project_name}-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled = true
    path                = "/"
    interval            = 300
    timeout             = 60
    healthy_threshold   = 5
    matcher = "200,301,302"
    unhealthy_threshold = 5
  }

lifecycle {
  create_before_destroy = true
}

}


# create https listener for load balancer
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# create http listener for load balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}
