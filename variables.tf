variable "region" {
  type        = string
  description = "The AWS region to deploy in"
  default     = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "The AWS key pair to use"
}

variable "instance_type" {
  type        = string
  description = "The instance type"
  default     = "t2.micro"
}

variable "ami" {
  type        = map(any)
  description = "A map of AMIs"
  default = {
    us-east-1 = "ami-04beabd6a4fb6ab6f"
  }
}

