#!/bin/bash
# ============================================================
# Solution Notes - Question 15: Node Labels & nodeSelector
# ============================================================
#
# STEP 1: Find the worker node
#   WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
#
# STEP 2: Label the node
#   kubectl label node $WORKER disktype=ssd zone=us-east-1a
#   kubectl get node $WORKER --show-labels   # verify
#
# STEP 3: Create ssd-pod with nodeSelector
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: ssd-pod
#     namespace: label-ns
#   spec:
#     nodeSelector:
#       disktype: ssd
#     containers:
#     - name: nginx
#       image: nginx:1.25
#   EOF
#
# STEP 4: Create any-pod with no nodeSelector
#   kubectl run any-pod --image=nginx:1.25 -n label-ns
#
# STEP 5: Verify placement
#   kubectl get pods -n label-ns -o wide
#   # ssd-pod NODE column should show $WORKER
#
# BONUS: Remove a label from a node
#   kubectl label node $WORKER disktype-    # trailing dash removes the label
#
# EXAM TIP: nodeSelector is a simple equality-based selector.
# For more complex rules (In, NotIn, Exists, etc.) use nodeAffinity.
# nodeSelector is faster to write under exam pressure.
# ============================================================
