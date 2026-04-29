#!/bin/bash
# ============================================================
# Solution Notes - Question 5: ConfigMap as Volume
# ============================================================
#
# STEP 1: Create the ConfigMap with the HTML content
#   kubectl create configmap html-config \
#     --from-literal='index.html=<html><body><h1>Hello from ConfigMap</h1></body></html>' \
#     -n web-ns
#
#   Or from a file (cleaner for HTML):
#   echo '<html><body><h1>Hello from ConfigMap</h1></body></html>' > index.html
#   kubectl create configmap html-config --from-file=index.html -n web-ns
#   rm index.html
#
# STEP 2: Create the Pod with ConfigMap volume mount
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: html-pod
#     namespace: web-ns
#   spec:
#     containers:
#     - name: nginx
#       image: nginx:1.25
#       volumeMounts:
#       - name: html
#         mountPath: /usr/share/nginx/html
#     volumes:
#     - name: html
#       configMap:
#         name: html-config
#   EOF
#
# STEP 3: Wait and verify
#   kubectl wait pod/html-pod -n web-ns --for=condition=Ready --timeout=60s
#   kubectl exec html-pod -n web-ns -- curl -s localhost
#   # Output: <html><body><h1>Hello from ConfigMap</h1></body></html>
#
# EXAM TIP: When a ConfigMap is mounted as a volume, each key
# becomes a file in the mount directory. The key name is the
# filename and the value is the file content.
# ============================================================
