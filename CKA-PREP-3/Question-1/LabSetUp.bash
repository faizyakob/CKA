#!/bin/bash
# ============================================================
# Lab Setup - Question 1: Liveness & Readiness Probes
# ============================================================
set -e

echo "[*] Creating namespace probe-ns..."
kubectl create namespace probe-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Lab setup complete. You may now attempt Question 1."
