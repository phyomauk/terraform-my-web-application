output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "blue_target_group_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  value = aws_lb_target_group.green.arn
}

output "blue_target_group_name" {
  value = aws_lb_target_group.blue.name
}

output "green_target_group_name" {
  value = aws_lb_target_group.green.name
}

output "production_listener_arn" {
  value = aws_lb_listener.production.arn
}

output "test_listener_arn" {
  value = aws_lb_listener.test.arn
}

output "alb_arn_suffix" {
  value = aws_lb.alb.arn_suffix
}

output "blue_target_group_arn_suffix" {
  value = aws_lb_target_group.blue.arn_suffix
}

output "green_target_group_arn_suffix" {
  value = aws_lb_target_group.green.arn_suffix
}