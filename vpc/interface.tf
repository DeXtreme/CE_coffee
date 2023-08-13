variable "name" {
  description = "VPC name"
}

variable "cidr" {
  description = "The CIDR of the VPC."
}

variable "public_subnet" {
  description = "The public subnet to create."
}

variable "private_subnet" {
  description = "The private subnet to create."
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}


output "vpc_id" {
  value = aws_vpc.tfb.id
}
output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

