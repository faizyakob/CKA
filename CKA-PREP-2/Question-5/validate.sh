#!/bin/bash
# ============================================================
# Validate - Question 5: ConfigMap as Volume
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 5"
echo "======================================"

check "ConfigMap 'html-config' exists in web-ns" \
  "kubectl get configmap html-config -n web-ns"

check "ConfigMap has key 'index.html'" \
  "kubectl get configmap html-config -n web-ns -o jsonpath='{.data.index\.html}' | grep -q html"

check "ConfigMap content contains 'Hello from ConfigMap'" \
  "kubectl get configmap html-config -n web-ns -o jsonpath='{.data.index\.html}' | grep -q 'Hello from ConfigMap'"

check "Pod 'html-pod' exists in web-ns" \
  "kubectl get pod html-pod -n web-ns"

check "Pod is Running" \
  "kubectl get pod html-pod -n web-ns -o jsonpath='{.status.phase}' | grep -q Running"

check "Pod mounts volume at /usr/share/nginx/html" \
  "kubectl get pod html-pod -n web-ns -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath==\"/usr/share/nginx/html\")].name}' | grep -q ."

check "Volume references ConfigMap 'html-config'" \
  "kubectl get pod html-pod -n web-ns -o jsonpath='{.spec.volumes[0].configMap.name}' | grep -q html-config"

check "nginx serves the custom HTML page" \
  "kubectl exec html-pod -n web-ns -- curl -s localhost | grep -q 'Hello from ConfigMap'"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
