#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 1"; echo "======================================"

check "ConfigMap 'app-cfg' exists in vol-ns" \
  "kubectl get configmap app-cfg -n vol-ns"
check "ConfigMap has key app.properties=env=staging" \
  "kubectl get configmap app-cfg -n vol-ns -o jsonpath='{.data.app\.properties}' | grep -q 'env=staging'"
check "Secret 'app-secret' exists in vol-ns" \
  "kubectl get secret app-secret -n vol-ns"
check "Secret has key 'token'" \
  "kubectl get secret app-secret -n vol-ns -o jsonpath='{.data.token}' | base64 -d | grep -q abc123"
check "Pod 'multi-vol-pod' exists in vol-ns" \
  "kubectl get pod multi-vol-pod -n vol-ns"
check "Pod is Running" \
  "kubectl get pod multi-vol-pod -n vol-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "emptyDir volume 'cache' is defined" \
  "kubectl get pod multi-vol-pod -n vol-ns -o jsonpath='{.spec.volumes[?(@.name==\"cache\")].emptyDir}' | grep -q ."
check "ConfigMap volume 'cfg' references app-cfg" \
  "kubectl get pod multi-vol-pod -n vol-ns -o jsonpath='{.spec.volumes[?(@.name==\"cfg\")].configMap.name}' | grep -q app-cfg"
check "Secret volume 'creds' references app-secret" \
  "kubectl get pod multi-vol-pod -n vol-ns -o jsonpath='{.spec.volumes[?(@.name==\"creds\")].secret.secretName}' | grep -q app-secret"
check "/etc/config/app.properties contains env=staging" \
  "kubectl exec multi-vol-pod -n vol-ns -- cat /etc/config/app.properties | grep -q 'env=staging'"
check "/etc/secret/token contains abc123" \
  "kubectl exec multi-vol-pod -n vol-ns -- cat /etc/secret/token | grep -q abc123"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
