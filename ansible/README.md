# ansible

## Step to install ansible on local workstation


### Install and configure the prerequisites tools 
- [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)


### Create and upload aws keypair
```bash
ssh-keygen -t rsa -f ~/.ssh/<Your_name>
aws ec2 describe-key-pairs
aws ec2 import-key-pair --region ap-south-1 --key-name "<Your_name>" --public-key-material file://~/.ssh/<Your_name>.pub
aws ec2 describe-key-pairs
```

### To setup K8, Please run below script.
```
sh +x k8_setup.sh
```

### To setup Linkerd, Please run below script.
```
sh +x linkerd_setup.sh
```
