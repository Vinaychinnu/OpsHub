#!/bin/bash
set -e

echo "=== Jenkins Installation Script ==="
echo ""
echo "Select your OS:"
echo "1) Ubuntu / Debian-based"
echo "2) Amazon Linux 2"
echo ""

read -p "Enter choice [1 or 2]: " OS_CHOICE

install_jenkins_ubuntu() {
  echo ""
  echo "Installing Jenkins on Ubuntu..."

  sudo apt update
  sudo apt install -y openjdk-17-jdk curl gnupg

  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

  sudo apt update
  sudo apt install -y jenkins

  sudo systemctl enable jenkins
  sudo systemctl start jenkins
}

install_jenkins_amazon_linux() {
  echo ""
  echo "Installing Jenkins on Amazon Linux 2..."

  sudo yum update -y
  sudo amazon-linux-extras install java-openjdk11 -y

  sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

  sudo yum install -y jenkins

  sudo systemctl enable jenkins
  sudo systemctl start jenkins
}

case "$OS_CHOICE" in
  1)
    install_jenkins_ubuntu
    ;;
  2)
    install_jenkins_amazon_linux
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

echo ""
echo "Jenkins installation completed."
echo ""
echo "Access Jenkins at:"
echo "  http://<your-server-ip>:8080"
echo ""
echo "Initial admin password:"
echo "  sudo cat /var/lib/jenkins/secrets/initialAdminPassword"