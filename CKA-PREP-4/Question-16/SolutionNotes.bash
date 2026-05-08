#!/bin/bash
# ============================================================
# Solution Notes - Question 16: Broken Pod Networking (CNI)
# ============================================================
#
# STEP 1: Observe symptoms
#   kubectl get pods -A
#   # Some pods may be in ContainerCreating (network not ready)
#
#   kubectl run test-pod --image=alpine:3.18 --restart=Never -- sleep 60
#   kubectl describe pod test-pod
#   # Events: Failed to create pod sandbox:
#   #         network plugin is not ready: cni config uninitialized
#   #         OR: no networks found in /etc/cni/net.d
#
# STEP 2: Check CNI config directory
#   ls -la /etc/cni/net.d/
#   # You will see: <config-file>.broken  (wrong extension!)
#   # Kubelet only reads .conf and .conflist files
#
# STEP 3: Check kubelet logs for confirmation
#   journalctl -u kubelet --since "5 minutes ago" | grep -i cni
#   # "no networks found in /etc/cni/net.d"
#
# STEP 4: Fix — rename the file back to its correct extension
#   CNI_DIR="/etc/cni/net.d"
#   BROKEN=$(ls $CNI_DIR/*.broken | head -1)
#
#   # Restore from backup:
#   cp "${BROKEN%.broken}.bak" "${BROKEN%.broken}"
#   # OR rename:
#   mv "$BROKEN" "${BROKEN%.broken}"
#
# STEP 5: Restart kubelet to pick up the restored CNI config
#   systemctl restart kubelet
#   sleep 10
#
# STEP 6: Verify pods can get IPs and communicate
#   kubectl run test1 --image=alpine:3.18 --restart=Never -- sleep 60
#   kubectl run test2 --image=alpine:3.18 --restart=Never -- sleep 60
#   kubectl wait pod/test1 pod/test2 --for=condition=Ready --timeout=60s
#
#   T2_IP=$(kubectl get pod test2 -o jsonpath='{.status.podIP}')
#   kubectl exec test1 -- ping -c 2 $T2_IP
#   # 2 packets transmitted, 2 received — networking is restored!
#
# CNI TROUBLESHOOTING CHECKLIST:
#   1. ls /etc/cni/net.d/      — check for .conf or .conflist files
#   2. ls /opt/cni/bin/        — check CNI binaries exist
#   3. journalctl -u kubelet   — check for CNI error messages
#   4. crictl pods             — check if sandbox creation fails
#   5. kubectl describe pod    — look for network plugin errors
# ============================================================
