#!/bin/bash

echo "installing amazon-ssm-agent "
sudo snap install amazon-ssm-agent --classic

echo "installing docker"
sudo yum update
sudo yum install -y docker
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker $USER

echo "installing package"
sudo yum install -y git

echo "rebooting"
sudo reboot