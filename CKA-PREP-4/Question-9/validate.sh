#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 9"; echo "======================================"

check "ConfigMap 'reload-cfg' exists in reload-ns" "kubectl get configmap reload-cfg -n reload-ns"
check "ConfigMap has been updated to Hello-v2" \
  "kubectl get configmap reload-cfg -n reload-ns -o jsonpath='{.data.message}' | grep -q Hello-v2"
check "Pod 'reload-pod' exists in reload-ns" "kubectl get pod reload-pod -n reload-ns"
check "Pod is Running" \
  "kubectl get pod reload-pod -n reload-ns -o jsonpath='{.status.phase}' | grep -q Running"
check "Pod mounts ConfigMap as volume at /etc/config" \
  "kubectl get pod reload-pod -n reload-ns -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath==\"/etc/config\")].name}' | grep -q ."
check "Pod RESTART count is 0 (not restarted to pick up change)" \
  "[ \$(kubectl get pod reload-pod -n reload-ns -o jsonpath='{.status.containerStatuses[0].restartCount}') -eq 0 ]"

echo ""
echo "  [INFO] Waiting up to 90s for ConfigMap to propagate into the Pod..."
for i in $(seq 1 9); do
  VAL=$(kubectl exec reload-pod -n reload-ns -- cat /etc/config/message 2>/dev/null)
  if echo "$VAL" | grep -q "Hello-v2"; then
    echo "  [PASS] /etc/config/message hot-reloaded to Hello-v2 (took ~${i}0s)"
    ((PASS++)); break
  fi
  sleep 10
done
if ! kubectl exec reload-pod -n reload-ns -- cat /etc/config/message 2>/dev/null | grep -q "Hello-v2"; then
  echo "  [FAIL] /etc/config/message still shows old value (propagation may need more time)"
  ((FAIL++))
fi

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
