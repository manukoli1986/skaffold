variable "ingress_ports" {
  type = list(number)
  description = "List of Ingress Port"
  default = [22,8080,80,30000-32768]
}