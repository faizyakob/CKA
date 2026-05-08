#!/bin/bash
# ============================================================
# Solution Notes - Question 8: hostNetwork & hostPID
# ============================================================
#
# STEP 1: Get control-plane node name
#   CP=$(kubectl get nodes --no-headers | grep control-plane | awk '{print $1}' | head -1)
#
# STEP 2: Create host-net-pod
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: host-net-pod
#     namespace: host-ns
#   spec:
#     hostNetwork: true
#     hostPID: false
#     nodeName: $CP
#     containers:
#     - name: app
#       image: alpine:3.18
#       command: ["sleep", "3600"]
#   EOF
#
# STEP 3: Create normal-pod (no hostNetwork)
#   kubectl run normal-pod --image=nginx:1.25 -n host-ns
#
# STEP 4: Wait and verify
#   kubectl wait pod/host-net-pod -n host-ns --for=condition=Ready --timeout=60s
#
#   # host-net-pod hostname = node hostname
#   kubectl exec host-net-pod -n host-ns -- hostname
#
#   # normal-pod hostname = pod name (auto-generated)
#   kubectl exec normal-pod -n host-ns -- hostname
#
#   # host-net-pod sees node network interfaces
#   kubectl exec host-net-pod -n host-ns -- ip addr | grep eth
#
# HOST NAMESPACE FLAGS:
#   hostNetwork: true  - Pod uses host's network namespace
#                        Pod IP = Node IP, can bind to node ports
#   hostPID: true      - Pod can see ALL processes on the node
#   hostIPC: true      - Pod shares host's IPC namespace
#
# SECURITY NOTE: These settings are restricted by PodSecurity
# admission in modern clusters. Use only for system pods
# (node agents, monitoring, network plugins).
# ============================================================
