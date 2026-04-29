#!/bin/bash
# ============================================================
# Solution Notes - Question 1: Init Containers
# ============================================================
#
# Init containers run and complete BEFORE main containers start.
# They share volumes with the main container, making them ideal
# for setup tasks (seeding files, waiting for dependencies, etc.)
#
# STEP 1: Write the Pod manifest
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: init-pod
#     namespace: init-ns
#   spec:
#     initContainers:
#     - name: init-setup
#       image: busybox:1.35
#       command: ["sh", "-c", "echo initialized > /work/status.txt"]
#       volumeMounts:
#       - name: workdir
#         mountPath: /work
#     containers:
#     - name: app
#       image: nginx:1.25
#       volumeMounts:
#       - name: workdir
#         mountPath: /work
#         readOnly: true
#     volumes:
#     - name: workdir
#       emptyDir: {}
#   EOF
#
# STEP 2: Wait for Pod to be Running
#   kubectl wait pod/init-pod -n init-ns --for=condition=Ready --timeout=60s
#
# STEP 3: Verify
#   kubectl exec init-pod -n init-ns -- cat /work/status.txt
#   # Output: initialized
#
# EXAM TIP: You can watch init container progress with:
#   kubectl get pod init-pod -n init-ns -w
#   # STATUS transitions: Init:0/1 -> PodInitializing -> Running
# ============================================================
