#!/bin/bash

sudo ansible-playbook ec2_playbook.yml --extra-vars instancetype=t2.micro securitygroup=ansible-webserver awsaminame=ami-41e9c52e keypairname=sample regionname=ap-south-1 dbpasswd=password
