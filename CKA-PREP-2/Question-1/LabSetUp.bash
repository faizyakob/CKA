#!/bin/bash
# ============================================================
# Lab Setup - Question 1: Init Containers
# ============================================================
set -e

echo "[*] Creating namespace init-ns..."
kubectl create namespace init-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 1."
