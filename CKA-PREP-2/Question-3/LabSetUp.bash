#!/bin/bash
# ============================================================
# Lab Setup - Question 3: Jobs & CronJobs
# ============================================================
set -e

echo "[*] Creating namespace batch-ns..."
kubectl create namespace batch-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 3."
