#!/bin/bash
set -e

echo "=== Starting Minikube with Docker driver ==="
minikube start --driver=docker --force

echo "=== Enabling metrics-server addon ==="
minikube addons enable metrics-server

echo "=== Verifying cluster ==="
kubectl get nodes
kubectl get pods -A

echo "=== Minikube is ready ==="
