#!/bin/bash
# ============================================================
# Solution Notes - Question 2: Multi-Container Pod (Sidecar)
# ============================================================
#
# STEP 1: Create the multi-container Pod
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: sidecar-pod
#     namespace: sidecar-ns
#   spec:
#     containers:
#     - name: app
#       image: nginx:1.25
#       volumeMounts:
#       - name: logs
#         mountPath: /var/log/nginx
#     - name: log-shipper
#       image: busybox:1.35
#       command: ["sh", "-c", "tail -f /var/log/nginx/access.log"]
#       volumeMounts:
#       - name: logs
#         mountPath: /var/log/nginx
#     volumes:
#     - name: logs
#       emptyDir: {}
#   EOF
#
# STEP 2: Wait for the Pod to be Ready
#   kubectl wait pod/sidecar-pod -n sidecar-ns --for=condition=Ready --timeout=60s
#
# STEP 3: Generate some nginx traffic so the log has entries
#   kubectl exec sidecar-pod -n sidecar-ns -c app -- curl -s localhost
#
# STEP 4: Verify the sidecar is reading logs
#   kubectl logs sidecar-pod -n sidecar-ns -c log-shipper
#
# EXAM TIP: Use -c <container-name> to target a specific container
# in a multi-container Pod for both exec and logs commands.
# ============================================================
