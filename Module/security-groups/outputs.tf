output "alb_sg_id"{
    value = aws_security_group.alb_sg.id
}

output "ecs_sg_id"{
    value = aws_security_group.ec2_sg.id
}