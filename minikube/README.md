# Minikube Setup on AWS EC2

This directory contains shell scripts to install and start a local Kubernetes cluster using **Minikube** on an **AWS EC2** instance.  
This setup is intended for **learning, development, and experimentation**.

---

## Files

- `install-minikube.sh`  
  Installs the required dependencies:
  - Docker
  - kubectl
  - Minikube

- `start-minikube.sh`  
  Starts Minikube using the Docker driver and enables basic addons.

---

## Prerequisites

- AWS EC2 instance running **Amazon Linux 2**
- User with `sudo` privileges
- Internet access

---

## Usage

### 1. Install dependencies

    chmod +x install-minikube.sh
    ./install-minikube.sh

After installation, log out and log back in to apply Docker group changes.

---

### 2. Start Minikube

    chmod +x start-minikube.sh
    ./start-minikube.sh

This will:
- Start Minikube using the Docker driver
- Enable the metrics-server addon
- Verify the Kubernetes cluster status

---

## Notes

- Minikube is started using the Docker driver (`minikube start --driver=docker`)
- This setup is meant for **development and learning**, not production
- Tested on **Amazon Linux 2**

---

## Author

Maintained as part of the **OpsHub** repository for practicing DevOps and Kubernetes tooling.
