#!/bin/bash
# ============================================================
# Lab Setup - Question 2: Static Pods
# ============================================================
set -e

echo "[*] Confirming /etc/kubernetes/manifests/ exists on control-plane..."
ls /etc/kubernetes/manifests/ && echo "[*] Static pod path confirmed."

echo "[*] No additional setup needed. Attempt Question 2."
