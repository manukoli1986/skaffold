output "EC2_Master_IP" {
  value = ["${aws_instance.k8master.public_ip}"]
}

output "EC2_WorkerNode_IP_1" {
  value = ["${aws_instance.k8worker.0.public_ip}"]
}
output "EC2_WorkerNode_IP_2" {
  value = ["${aws_instance.k8worker.1.public_ip}"]
}