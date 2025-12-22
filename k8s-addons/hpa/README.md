# Horizontal Pod Autoscaler (HPA)

This directory demonstrates **Horizontal Pod Autoscaling (HPA)** in Kubernetes using a simple Deployment and CPU-based scaling.

HPA automatically adjusts the number of pod replicas based on resource usage, such as CPU.

---

## What this setup does

- Deploys a simple nginx-based application
- Configures CPU requests required for autoscaling
- Creates a Horizontal Pod Autoscaler
- Scales pods up and down based on CPU utilization

This setup uses **Metrics Server** for collecting CPU metrics.

---

## Files

- deployment.yaml  
  Defines a sample Deployment with CPU requests and limits.

- hpa.yaml  
  Defines a Horizontal Pod Autoscaler that scales the Deployment based on CPU usage.

---

## Prerequisites

- A running Kubernetes cluster
- Metrics Server installed and working
- kubectl configured with the correct cluster context

---

## Setup

Apply the Deployment:

    kubectl apply -f deployment.yaml

Apply the HPA:

    kubectl apply -f hpa.yaml

Verify that the HPA is created:

    kubectl get hpa

You should see CPU metrics instead of `<unknown>`.

---

## Generate load

To trigger autoscaling, generate HTTP load on the application.

Start a temporary load generator pod:

    kubectl run load-generator \
      --rm -it \
      --image=busybox \
      --restart=Never \
      -- sh

Inside the pod, run:

    while true; do wget -q -O- http://demo-deployment; done

---

## Observe autoscaling

Watch the HPA behavior:

    kubectl get hpa -w

In another terminal, watch pods scale:

    kubectl get pods -w

You should see the number of pods increase when CPU usage rises and decrease after stopping the load.

---

## Notes

- HPA uses CPU requests as the baseline for scaling decisions
- The `replicas` field in the Deployment is overridden by HPA