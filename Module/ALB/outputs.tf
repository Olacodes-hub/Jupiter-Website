output "alb_tg_arn" {
   value = aws_lb_target_group.tg.arn
}

output "alb_dns_name" {
   value = aws_lb.application_load_balancer.dns_name
}

output "alb_zone_id" {
   value = aws_lb.application_load_balancer.zone_id
}