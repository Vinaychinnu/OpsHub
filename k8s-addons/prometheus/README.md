# Prometheus & Grafana Setup

This directory contains a script to install **Prometheus, Grafana, and Alertmanager** in a Kubernetes cluster using Helm.

The setup uses the **kube-prometheus-stack**, which is the standard and widely used monitoring stack for Kubernetes.

---

## What this setup does

- Installs Prometheus for collecting cluster and application metrics
- Installs Grafana for visualizing metrics
- Installs Alertmanager for handling alerts
- Deploys all components into a dedicated `monitoring` namespace

This setup works with any Kubernetes cluster that your current kubeconfig context points to.

---

## Files

- install-prometheus.sh  
  Installs Prometheus, Grafana, and Alertmanager using Helm.

---

## Installation

Run the installation script:

    chmod +x install-prometheus.sh
    ./install-prometheus.sh

---

## Kubernetes context (important)

Prometheus and Grafana are installed into the Kubernetes cluster that your current `kubectl` context points to.

Before running the script, verify the active cluster:

    kubectl config current-context
    kubectl get nodes

The installation will apply to that cluster.

---

## Verification

Check that the monitoring components are running:

    kubectl get pods -n monitoring

You should see pods related to:
- Prometheus
- Grafana
- Alertmanager
- Node exporters

---

## Accessing Grafana

Grafana is not exposed externally by default.

To access Grafana locally, use port forwarding:

    kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

Then open your browser and visit:

    http://localhost:3000

---

## Grafana login credentials

Default credentials are:

    Username: admin
    Password: prom-operator

You will be prompted to change the password after logging in.

---

## Notes

- This setup does not require Ingress or TLS
- Further customization can be done using Helm values