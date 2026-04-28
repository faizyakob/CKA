#!/bin/bash
# ============================================================
# Solution Notes - Question 7: Taints, Tolerations & Node Affinity
# ============================================================
#
# STEP 1: Find the worker node name
#   WORKER=$(kubectl get nodes --no-headers | grep -v control-plane | awk '{print $1}' | head -1)
#   echo $WORKER
#
# STEP 2: Taint the worker node
#   kubectl taint node $WORKER workload=gpu:NoSchedule
#
# STEP 3: Create the Pod manifest with toleration + node affinity
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: gpu-pod
#     namespace: default
#   spec:
#     tolerations:
#     - key: "workload"
#       operator: "Equal"
#       value: "gpu"
#       effect: "NoSchedule"
#     affinity:
#       nodeAffinity:
#         preferredDuringSchedulingIgnoredDuringExecution:
#         - weight: 1
#           preference:
#             matchExpressions:
#             - key: accelerator
#               operator: In
#               values:
#               - gpu
#     containers:
#     - name: nginx
#       image: nginx:1.25
#   EOF
#
# STEP 4: Verify
#   kubectl get pod gpu-pod -o wide
#
# EXAM TIP: 'required' affinity (requiredDuringScheduling...) will
# prevent scheduling if no node matches. 'preferred' is softer —
# the scheduler will try but won't block. Use 'preferred' when
# you want hints, not hard rules.
# ============================================================
