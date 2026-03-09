# Docker

This directory contains a script to install Docker Engine on a Linux host.

Docker is used as the container runtime for local development and Kubernetes tooling.

---

## Files

- `install-docker.sh`  
  Installs Docker Engine, CLI tools, container runtime, and Docker Compose plugin.

---

## Installation

Run the installation script:

    chmod +x install-docker.sh
    ./install-docker.sh

---

## Post Installation

The script adds the current user to the `docker` group to allow running Docker without `sudo`.

Log out and log back in for the group change to take effect.

---

## Verification

Check the Docker installation:

    docker --version

Run a test container:

    docker run hello-world