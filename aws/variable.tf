variable "ingress_ports" {
  type = list(number)
  description = "List of Ingress Port"
  default = [22,8080,80]
}

variable "aws_existed_key_name" {
  default = "~/Downloads/mayank-macos.pem"
}

variable "user" {
  default = "ec2-user"
}