#!/bin/bash
set -e
echo "[*] Creating namespace dev-team..."
kubectl create namespace dev-team --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Pre-generating bob's private key and CSR..."
openssl genrsa -out /tmp/bob.key 2048 2>/dev/null
openssl req -new -key /tmp/bob.key -out /tmp/bob.csr \
  -subj "/CN=bob/O=dev-team" 2>/dev/null

echo "[*] Files ready:"
echo "    Private key: /tmp/bob.key"
echo "    CSR:         /tmp/bob.csr"
echo ""
echo "[*] Lab setup complete. You may now attempt Question 15."
