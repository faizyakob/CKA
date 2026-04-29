#!/bin/bash
# ============================================================
# Validate - Question 10: HorizontalPodAutoscaler
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 10"
echo "======================================"

check "HPA 'hpa-app-hpa' exists in hpa-ns" \
  "kubectl get hpa hpa-app-hpa -n hpa-ns"

check "HPA targets deployment hpa-app" \
  "kubectl get hpa hpa-app-hpa -n hpa-ns -o jsonpath='{.spec.scaleTargetRef.name}' | grep -q hpa-app"

check "HPA minReplicas is 2" \
  "kubectl get hpa hpa-app-hpa -n hpa-ns -o jsonpath='{.spec.minReplicas}' | grep -q 2"

check "HPA maxReplicas is 6" \
  "kubectl get hpa hpa-app-hpa -n hpa-ns -o jsonpath='{.spec.maxReplicas}' | grep -q 6"

check "HPA target CPU utilisation is 50%" \
  "kubectl get hpa hpa-app-hpa -n hpa-ns -o json | grep -q '\"averageUtilization\":50\|\"targetAverageUtilization\":50'"

check "Deployment hpa-app is running" \
  "kubectl rollout status deployment/hpa-app -n hpa-ns --timeout=10s"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
