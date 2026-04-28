#!/bin/bash
# ============================================================
# Solution Notes - Question 17: TLS Configuration with nginx
# ============================================================
#
# STEP 1: Edit the ConfigMap to remove TLSv1.2
#   kubectl edit configmap nginx-config -n nginx-static
#
#   Find the line:
#     ssl_protocols TLSv1.2 TLSv1.3;
#   Change it to:
#     ssl_protocols TLSv1.3;
#   Save and exit.
#
#   Or do it imperatively:
#   kubectl get configmap nginx-config -n nginx-static -o yaml > nginx-config.yaml
#   sed -i 's/ssl_protocols TLSv1.2 TLSv1.3;/ssl_protocols TLSv1.3;/' nginx-config.yaml
#   kubectl apply -f nginx-config.yaml
#
# STEP 2: Get the Service ClusterIP and add to /etc/hosts
#   SVC_IP=$(kubectl get svc nginx-service -n nginx-static \
#     -o jsonpath='{.spec.clusterIP}')
#   echo "$SVC_IP  ckaquestion.k8s.local" >> /etc/hosts
#
# STEP 3: Restart the deployment to pick up the new ConfigMap
#   kubectl rollout restart deployment/nginx-static -n nginx-static
#   kubectl rollout status deployment/nginx-static -n nginx-static
#
# STEP 4: Verify TLS behaviour
#   # Should FAIL — TLSv1.2 is disabled:
#   curl -vk --tls-max 1.2 https://ckaquestion.k8s.local
#   # Look for: SSL routines::no protocols available  OR  connection refused
#
#   # Should SUCCEED — TLSv1.3 is enabled:
#   curl -vk --tlsv1.3 https://ckaquestion.k8s.local
#   # Look for: HTTP/1.1 200 OK  and  CKA TLS Question OK
#
# EXAM TIP: nginx only reloads config when the process restarts.
# Since ConfigMaps are mounted as volumes, a rollout restart is
# required to apply the changes. Use:
#   kubectl rollout restart deployment/<name> -n <namespace>
# ============================================================
