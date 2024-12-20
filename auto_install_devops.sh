#!/bin/bash

echo "This script installs all the required modules for DevOps"

read -p "Please, write your OS (1 - AWS Linux, Fedora, or CentOS, 2 - Ubuntu or Debian): " system_type
read -p "Do you want to install Ansible? (1 - yes, 0 - no): " ansible_st

if [[ "$ansible_st" == 1 && "$system_type" == 1 ]]; then
    sudo yum update -y
    sudo yum install -y epel-release
    sudo yum install -y python3 python3-pip ansible
    ansible --version
elif [[ "$ansible_st" == 1 && "$system_type" == 2 ]]; then
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install -y software-properties-common python3 python3-pip
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
    ansible --version
else
    echo "Skipping Ansible installation..."
fi

read -p "Do you want to install Git? (1 - yes, 0 - no): " git_st

if [[ "$git_st" == 1 && "$system_type" == 1 ]]; then
    sudo yum update -y
    sudo yum install -y git
    git --version
elif [[ "$git_st" == 1 && "$system_type" == 2 ]]; then
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install -y git
    git --version
else
    echo "Skipping Git installation..."
fi

read -p "Do you want to install Jenkins? (1 - yes, 0 - no): " jenkins_st

if [[ "$jenkins_st" == 1 && "$system_type" == 1 ]]; then
    sudo yum update -y
    sudo yum install -y java-11-amazon-corretto
    sudo curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo yum install -y jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sudo systemctl status jenkins
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
elif [[ "$jenkins_st" == 1 && "$system_type" == 2 ]]; then
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install openjdk-17-jdk
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install jenkins -y
    sudo service jenkins start
    sudo systemctl enable jenkins
    sudo service jenkins status 
else
    echo "Skipping Jenkins installation..."
fi

echo "The script has finished!"

