resource "aws_security_group" "sg" {
  name = "Allow All Traffic"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = 0 #ingress.value
      to_port     = 65535 #ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

###### Master Node
resource "aws_instance" "k8master" {
  tags = {
    Name = "Master",
    Cluster = "K8s-Cluster"
  }
  ami           = "ami-0cca134ec43cf708f"
  instance_type = "t2.medium"
  key_name      = "mayank-macos"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  connection {
      type     = "ssh"
      host     = "${self.public_ip}"
      user     = "${var.user}"
      private_key = "${file(var.aws_existed_key_name)}"
      timeout	 = "5m"
  }
  provisioner "file" {
    source = "./pre-script.sh"
    destination  = "/tmp/pre-script.sh"
  }
  provisioner "remote-exec" {
    inline = [
        "sudo sh +x /tmp/pre-script.sh"
        # "sudo docker stack deploy --compose-file docker-compose.yaml webapp",
        # "echo ################### Please wait for 10 Seconds as container are starting UP ######################"
        ]
  }
}

#### Worker Node
resource "aws_instance" "k8worker" {
  count = 1
  tags = {
    Name = "Worker-${count.index}",
    Cluster = "K8s-Cluster" 
  }
  ami           = "ami-0cca134ec43cf708f"
  instance_type = "t2.medium"
  key_name      = "mayank-macos"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  connection {
      type     = "ssh"
      host     = "${self.public_ip}"
      user     = "${var.user}"
      private_key = "${file(var.aws_existed_key_name)}"
      timeout	 = "5m"
  }
  provisioner "file" {
    source = "./pre-script.sh"
    destination  = "/tmp/pre-script.sh"
  }
  provisioner "remote-exec" {
    inline = [
        "sudo sh +x /tmp/pre-script.sh"
        # "sudo docker stack deploy --compose-file docker-compose.yaml webapp",
        # "echo ################### Please wait for 10 Seconds as container are starting UP ######################"
        ]
  }
}


resource "null_resource" "host_file" {
depends_on = [aws_instance.k8master]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<EOT
      echo [masters] > ../ansible/hosts
      echo "master ansible_host=${aws_instance.k8master.public_ip} ansible_user=ec2-user ansible_ssh_common_args='"-o StrictHostKeyChecking=no"' ansible_ssh_private_key_file=~/Downloads/mayank-macos.pem" >> ../ansible/hosts
      echo [workers] >> ../ansible/hosts
      echo "worker1 ansible_host=${aws_instance.k8worker.0.public_ip} ansible_user=ec2-user ansible_ssh_common_args='"-o StrictHostKeyChecking=no"' ansible_ssh_private_key_file=~/Downloads/mayank-macos.pem" >> ../ansible/hosts
      echo "worker2 ansible_host=${aws_instance.k8worker.1.public_ip} ansible_user=ec2-user ansible_ssh_common_args='"-o StrictHostKeyChecking=no"' ansible_ssh_private_key_file=~/Downloads/mayank-macos.pem" >> ../ansible/hosts
    EOT
  }
}

# terraform output -raw EC2_Master_IP