#!/bin/bash


ansible -i hosts all -m ping
ansible-playbook -i hosts linkerd.yaml -vv