#!/bin/bash


ansible -i hosts all -m ping
ansible-playbook -i hosts user.yml -vv
# ansible-playbook -i hosts install-k8s.yml -vv
ansible-playbook -i hosts master.yml -vv
ansible-playbook -i hosts worker.yml -vv