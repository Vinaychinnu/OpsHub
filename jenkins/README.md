# Jenkins Setup

This directory contains a shell script to install and start Jenkins on a Linux machine or virtual machine.

The purpose of this setup is to provide a basic, working Jenkins instance for learning, experimentation, and DevOps practice.

---

## What this setup does

- Installs Jenkins using the official Jenkins repositories
- Installs the required Java runtime
- Starts the Jenkins service
- Enables Jenkins to start automatically on system boot

This setup is intended for single-node Jenkins usage.

---

## Supported Operating Systems

The installation script supports the following operating systems:

- Ubuntu / Debian-based systems
- Amazon Linux 2

---

## Files

- install-jenkins.sh  
  Script that installs Jenkins based on the selected OS.

---

## Usage

### 1. Run the installation script

    chmod +x install-jenkins.sh
    ./install-jenkins.sh


---

### 2. Access Jenkins

After installation, Jenkins will be accessible at:

    http://<your-server-ip>:8080

---

### 3. Get initial admin password

To complete the Jenkins setup, retrieve the initial admin password using:

    sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Use this password on the Jenkins UI to unlock Jenkins and complete the initial configuration.

---

## Notes

- Jenkins runs as a system service using systemd
- Further configuration such as plugins, jobs, and pipelines can be done via the Jenkins UI
