# OpsHub

OpsHub is a collection of infrastructure automation artifacts used to bootstrap container tooling, provision Kubernetes clusters, and deploy common platform add-ons.

The repository is organized around the lifecycle of a cloud-native environment:

    host tooling
        → cluster provisioning
            → Kubernetes platform add-ons
                → DevOps ecosystem components

Each directory represents a focused capability and can be used independently depending on the target environment.

---

## Repository Layout

    OpsHub/
    ├── automation/
    │   └── ansible/
    │
    ├── container-tools/
    │   ├── docker/
    │   └── helm/
    │
    ├── cluster-setup/
    │   ├── minikube/
    │   └── kops/
    │
    ├── devops-tools/
    │   ├── jenkins/
    │   ├── nexus/
    │   ├── sonar/
    │   └── tomcat/
    │
    └── k8s-addons/
        ├── cert-manager/
        ├── hpa/
        ├── ingress-debug/
        ├── ingress-nginx/
        ├── ingress-path-routing/
        ├── ingress-tls/
        ├── metrics-server/
        ├── network-policy/
        ├── pod-security/
        ├── prometheus/
        └── rbac/

---

## Architecture Overview

The repository follows a layered infrastructure model.

### 1. Container Tooling

Tools required on the host to build and run containerized workloads.

    container-tools/
        docker/
        helm/

Docker provides the container runtime while Helm is used as the package manager for Kubernetes deployments.

---

### 2. Cluster Provisioning

Cluster creation and lifecycle management.

    cluster-setup/
        minikube/
        kops/

Minikube enables local Kubernetes clusters for development and experimentation.

kOps automates provisioning of production-grade Kubernetes clusters on AWS using infrastructure primitives such as EC2, Auto Scaling Groups, and S3 state stores.

---

### 3. Kubernetes Add-ons

Platform extensions deployed inside Kubernetes clusters.

    k8s-addons/

These components extend core cluster functionality.

Examples include:

    ingress-nginx
        north-south traffic entrypoint

    cert-manager
        certificate lifecycle management

    metrics-server
        cluster resource metrics

    prometheus
        monitoring and observability

    hpa
        horizontal workload scaling

    rbac
        access control examples

    network-policy
        workload network isolation

    pod-security
        container runtime security configuration

Each directory contains the manifests or installation scripts required for the component.

---

### 4. DevOps Platform Components

Supporting tools used in CI/CD pipelines and application delivery.

    devops-tools/
        jenkins/
        nexus/
        sonar/
        tomcat/

These services represent common elements of a software delivery platform:

    Jenkins
        continuous integration

    Nexus
        artifact repository

    SonarQube
        code quality analysis

    Tomcat
        application runtime

---

### 5. Automation

Configuration automation utilities.

    automation/
        ansible/

This directory is reserved for playbooks and automation workflows used to manage infrastructure or platform configuration.

---

## Typical Workflow

A typical environment setup using this repository might follow a sequence similar to:

    install container tooling
        docker
        helm

    create a Kubernetes cluster
        minikube (local)
        or
        kops (cloud)

    deploy platform add-ons
        ingress
        monitoring
        autoscaling
        security policies

    install DevOps platform services
        Jenkins
        Nexus
        SonarQube

The directories are intentionally decoupled so that each component can be deployed independently.

---

## Design Principles

This repository follows a few guiding ideas:

    small focused scripts
    explicit infrastructure layout
    reproducible environments
    minimal external dependencies

Each folder represents a single responsibility rather than a monolithic installation process.

---

## Notes

The repository is intended as an infrastructure toolbox rather than a single deployable platform.

Scripts and manifests are provided as reference implementations and starting points for infrastructure automation workflows.