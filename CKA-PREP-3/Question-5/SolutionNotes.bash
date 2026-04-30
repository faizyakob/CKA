#!/bin/bash
# ============================================================
# Solution Notes - Question 5: SecurityContext
# ============================================================
#
# STEP 1: Create the Pod
#   cat <<EOF | kubectl apply -f -
#   apiVersion: v1
#   kind: Pod
#   metadata:
#     name: secure-ctx-pod
#     namespace: sec-ns
#   spec:
#     securityContext:
#       runAsNonRoot: true
#       runAsUser: 1000
#       runAsGroup: 3000
#       fsGroup: 2000
#     containers:
#     - name: app
#       image: busybox:1.35
#       command: ["sleep", "3600"]
#       securityContext:
#         allowPrivilegeEscalation: false
#         readOnlyRootFilesystem: true
#         capabilities:
#           drop: ["ALL"]
#       volumeMounts:
#       - name: writable
#         mountPath: /tmp/writable
#     volumes:
#     - name: writable
#       emptyDir: {}
#   EOF
#
# STEP 2: Verify
#   kubectl exec secure-ctx-pod -n sec-ns -- id
#   # uid=1000 gid=3000 groups=2000
#
#   kubectl exec secure-ctx-pod -n sec-ns -- touch /tmp/writable/test
#   # works — emptyDir is writable
#
#   kubectl exec secure-ctx-pod -n sec-ns -- touch /test
#   # Read-only file system error — correct!
#
# SECURITY CONTEXT FIELDS EXPLAINED:
#   runAsNonRoot   - rejects container if UID=0 (root)
#   runAsUser      - UID to run container process as
#   runAsGroup     - GID to run container process as
#   fsGroup        - GID applied to mounted volumes (for file ownership)
#   allowPrivilegeEscalation: false - prevents sudo/setuid binaries
#   readOnlyRootFilesystem   - mounts container root fs as read-only
#   capabilities.drop: ALL  - removes all Linux capabilities
#
# EXAM TIP: SecurityContext at pod level applies to ALL containers.
# Container-level overrides pod-level for the same field.
# ============================================================
