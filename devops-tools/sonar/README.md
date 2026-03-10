# SonarQube Setup

This directory contains a shell script to install and run **SonarQube** on a Linux machine or virtual machine.


---

## What this setup does

- Installs Java (required by SonarQube)
- Installs and configures PostgreSQL as the backend database
- Downloads the official SonarQube LTS distribution
- Runs SonarQube as a non-root system user
- Configures SonarQube as a systemd service

This results in a **persistent, single-node SonarQube instance**.

---

## Why PostgreSQL is used

SonarQube requires a database to store:
- Code analysis results
- Issues and metrics
- Projects and users
- Historical scan data

PostgreSQL is the **only production-supported database** for SonarQube.
Embedded databases are meant only for testing and are not suitable for real usage.

---

## Supported Operating Systems

The installation script supports:

- Ubuntu / Debian-based systems
- Amazon Linux 2


---

## Files

- install-sonarqube.sh  
  Installs and configures SonarQube along with PostgreSQL.

---

## Usage

### 1. Run the installation script

    chmod +x install-sonarqube.sh
    ./install-sonarqube.sh

Choose the operating system from the options shown.

---

### 2. Access SonarQube

After installation completes, access SonarQube at:

    http://<your-server-ip>:9000

---

### 3. Default login credentials

Use the following credentials for the first login:

    Username: admin
    Password: admin

You will be prompted to change the password after logging in.

---

## Notes

- SonarQube runs as a system service using systemd