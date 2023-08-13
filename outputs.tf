output "elb_address" {
  value = aws_elb.elb.dns_name
}

output "frontend_address" {
  value = aws_instance.frontend.public_ip
}