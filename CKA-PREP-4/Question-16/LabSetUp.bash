#!/bin/bash
# ============================================================
# Lab Setup - Question 16: Troubleshoot Broken Pod Networking
# ============================================================
# WARNING: This breaks pod-to-pod networking. Fresh session only.
# ============================================================
set -e

CNI_DIR="/etc/cni/net.d"
CNI_FILE=$(ls $CNI_DIR/*.conf $CNI_DIR/*.conflist 2>/dev/null | head -1)

if [ -z "$CNI_FILE" ]; then
  echo "[!] No CNI config file found in $CNI_DIR"
  echo "    Contents: $(ls $CNI_DIR/)"
  exit 1
fi

echo "[*] Found CNI config: $CNI_FILE"
echo "[*] Backing up and renaming to break CNI..."
cp "$CNI_FILE" "${CNI_FILE}.bak"
mv "$CNI_FILE" "${CNI_FILE}.broken"

echo "[*] Restarting kubelet to clear CNI state..."
systemctl restart kubelet
sleep 10

echo ""
echo "[*] Lab is ready. CNI config has been renamed to .broken"
echo "    New pods will fail with network plugin errors."
echo ""
echo "    Investigate:"
echo "      ls /etc/cni/net.d/"
echo "      kubectl describe pod <stuck-pod>"
echo "      journalctl -u kubelet | grep cni"
echo ""
echo "    HINT: The fix is simple — the CNI config file has the wrong extension."
echo "    Backup saved as: ${CNI_FILE}.bak"
