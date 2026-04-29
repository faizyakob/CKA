#!/bin/bash
# ============================================================
# Lab Setup - Question 14: Certificate Signing Request
# ============================================================
set -e

echo "[*] Generating private key and CSR for user 'jane'..."
openssl genrsa -out /tmp/jane.key 2048 2>/dev/null

openssl req -new \
  -key /tmp/jane.key \
  -out /tmp/jane.csr \
  -subj "/CN=jane/O=developers" 2>/dev/null

echo "[*] CSR generated at /tmp/jane.csr"
echo "[*] Private key at /tmp/jane.key"
echo ""
echo "[*] Base64 encoded CSR (you'll need this for the manifest):"
cat /tmp/jane.csr | base64 | tr -d '\n'
echo ""
echo ""
echo "[*] Lab setup complete. You may now attempt Question 14."
