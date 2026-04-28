#!/bin/bash
# ============================================================
# Lab Setup - Question 12: Ingress
# ============================================================
set -e

echo "[*] Creating namespace ingress-ns..."
kubectl create namespace ingress-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating service-a deployment and service..."
kubectl create deployment service-a --image=nginx:1.25 -n ingress-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl expose deployment service-a --port=80 --target-port=80 -n ingress-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating service-b deployment and service..."
kubectl create deployment service-b --image=nginx:1.25 -n ingress-ns --dry-run=client -o yaml | kubectl apply -f -
kubectl expose deployment service-b --port=80 --target-port=80 -n ingress-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Waiting for deployments..."
kubectl rollout status deployment/service-a -n ingress-ns --timeout=60s
kubectl rollout status deployment/service-b -n ingress-ns --timeout=60s

echo "[*] Lab setup complete. You may now attempt Question 12."
echo "    NOTE: This lab assumes an nginx IngressController is installed."
echo "    On Killercoda CKA playground it is pre-installed."
