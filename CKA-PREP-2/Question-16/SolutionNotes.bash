#!/bin/bash
# ============================================================
# Solution Notes - Question 16: Troubleshoot Broken kubelet
# ============================================================
#
# STEP 1: Identify the NotReady node
#   kubectl get nodes
#   # Worker node shows: NotReady
#
# STEP 2: SSH into the worker node
#   WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
#   ssh $WORKER
#
# STEP 3: Check kubelet status
#   systemctl status kubelet
#   # Shows: inactive (dead) or disabled
#
# STEP 4: Check kubelet logs for root cause
#   journalctl -u kubelet -n 50
#   # Will show the kubelet was stopped/disabled
#
# STEP 5: Start and re-enable kubelet
#   systemctl start kubelet
#   systemctl enable kubelet
#   systemctl status kubelet    # verify: active (running)
#   exit
#
# STEP 6: Verify node recovers (from control-plane)
#   kubectl get nodes -w
#   # Worker transitions: NotReady -> Ready (within ~60s)
#
# COMMON KUBELET ISSUES ON THE EXAM:
#   - kubelet stopped:         systemctl start kubelet
#   - wrong config file path:  check /var/lib/kubelet/config.yaml
#   - wrong kubeconfig:        check /etc/kubernetes/kubelet.conf
#   - wrong staticPodPath:     grep staticPodPath /var/lib/kubelet/config.yaml
#   - certificate expired:     check /var/lib/kubelet/pki/
#
# EXAM TIP: For any node troubleshooting, the workflow is:
#   1. kubectl get nodes        (find the broken node)
#   2. kubectl describe node    (check conditions and events)
#   3. ssh <node>               (investigate on the node)
#   4. systemctl status kubelet (most common cause)
#   5. journalctl -u kubelet    (detailed error messages)
# ============================================================
