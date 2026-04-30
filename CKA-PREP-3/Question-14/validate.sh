#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 14"; echo "======================================"

check "Pod 'cache-pod' exists in affinity-ns with label app=cache" \
  "kubectl get pod cache-pod -n affinity-ns -l app=cache"

check "cache-pod is Running" \
  "kubectl get pod cache-pod -n affinity-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "Pod 'app-pod' exists in affinity-ns" \
  "kubectl get pod app-pod -n affinity-ns"

check "app-pod is Running" \
  "kubectl get pod app-pod -n affinity-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "app-pod has podAffinity defined" \
  "kubectl get pod app-pod -n affinity-ns -o jsonpath='{.spec.affinity.podAffinity}' | grep -q required"

check "app-pod and cache-pod are on the same node" \
  "APP_NODE=\$(kubectl get pod app-pod -n affinity-ns -o jsonpath='{.spec.nodeName}'); \
   CACHE_NODE=\$(kubectl get pod cache-pod -n affinity-ns -o jsonpath='{.spec.nodeName}'); \
   [ \"\$APP_NODE\" = \"\$CACHE_NODE\" ]"

check "Deployment 'web-deploy' exists with 3 replicas" \
  "kubectl get deployment web-deploy -n affinity-ns"

check "web-deploy has 3 ready replicas" \
  "[ \$(kubectl get deployment web-deploy -n affinity-ns -o jsonpath='{.status.readyReplicas}') -eq 3 ]"

check "web-deploy has podAntiAffinity defined" \
  "kubectl get deployment web-deploy -n affinity-ns \
     -o jsonpath='{.spec.template.spec.affinity.podAntiAffinity}' | grep -q preferred"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
