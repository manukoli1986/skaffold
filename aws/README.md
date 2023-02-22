# aws-ec2-k8

## Step to setup Kubernetes Cluster on EC2 machines


### Install and configure the prerequisites tools 
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)



### Create and upload aws keypair
```bash
ssh-keygen -t rsa -f ~/.ssh/<Your_name>
aws ec2 describe-key-pairs
aws ec2 import-key-pair --region ap-south-1 --key-name "<Your_name>" --public-key-material file://~/.ssh/<Your_name>.pub
aws ec2 describe-key-pairs
```

### Clone the code 

```bash
git clone https://github.com/manukoli1986/aws-ec2-k8.git
```

### Go to directory "aws-ec2-k8"

```bash
cd aws-ec2-k8
```

### Check main.tf file 

### Init and apply terraform

```bash
terraform init
terraform approve ## Type Yes 
```

### Connect to EC2
```bash 
ssh ec2-user@ec2-ip-address-dns-name-here
```
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################
##########################################################################################################################

# Installing Kubeadm on Linux Virtual Machine
Kubeadm is a tool that helps you to set up a production-grade Kubernetes cluster with ease. This guide will show you how to install Kubeadm on a Linux virtual machine.


#### Prerequisites
- A Linux virtual machine with at least 2 GB of RAM and 2 CPU cores.
- A non-root user with sudo privileges.
- A compatible Linux host with distributions on Red Hat, and those distributions without a package manager.
- Full network connectivity between all machines in the cluster
- Use Unique hostname, MAC address, and product_uuid for every node
- <b>Swap must be disabled.</b> You MUST disable swap in order for the kubelet to work properly.



### Step 1: Install Docker
Kubeadm requires Docker to run containers. Install Docker by following the instructions in the Docker documentation for your Linux distribution.

```
ssh ec2-user@ec2-ip-address-dns-name-here
```

```bash
sudo yum update -y
sudo yum search docker
sudo yum install docker -y 
sudo usermod -a -G docker ec2-user
id ec2-user
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl restart docker
sudo systemctl status docker.service
```

### Step 2: Add the Kubernetes repository
Add the Kubernetes repository to your system so that you can install the latest version of Kubeadm.

```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
```

### Step 3: Install Kubeadm, Kubelet, and Kubectl
Use the following command to install Kubeadm, Kubelet, and Kubectl:

- kubeadm: the command to use to bootstrap the cluster.
- kubelet: the component that runs on all of the machines in your cluster.
- kubectl: the command line utility to talk to your cluster.

```bash
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

sudo systemctl enable --now kubelet
```


### Step 4: Initialize the Cluster
Use the following command to initialize the cluster:

```bash
sudo kubeadm init
```
Follow the instructions displayed on the screen to configure your cluster.

### Step 5: Join Nodes to the Cluster
To join nodes to the cluster, use the kubeadm join command. You can find the command in the output of the kubeadm init command.

### Step 6: Configure Kubernetes CLI
To configure the Kubernetes CLI, run the following command:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Conclusion
With these steps, you should have a working Kubernetes cluster with Kubeadm. You can now deploy your applications on the cluster.