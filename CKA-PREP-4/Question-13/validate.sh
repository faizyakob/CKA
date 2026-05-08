#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 13"; echo "======================================"

check "PVC 'expand-pvc' exists in expand-ns" \
  "kubectl get pvc expand-pvc -n expand-ns"

check "PVC is Bound" \
  "kubectl get pvc expand-pvc -n expand-ns -o jsonpath='{.status.phase}' | grep -q Bound"

check "PVC requested storage is 500Mi" \
  "kubectl get pvc expand-pvc -n expand-ns -o jsonpath='{.spec.resources.requests.storage}' | grep -q 500Mi"

check "PVC actual capacity is 500Mi (filesystem resized)" \
  "kubectl get pvc expand-pvc -n expand-ns -o jsonpath='{.status.capacity.storage}' | grep -q 500Mi"

check "StorageClass has allowVolumeExpansion: true" \
  "SC=\$(kubectl get pvc expand-pvc -n expand-ns -o jsonpath='{.spec.storageClassName}'); \
   kubectl get storageclass \$SC -o jsonpath='{.allowVolumeExpansion}' | grep -q true"

check "Deployment 'expand-app' pod is Running" \
  "kubectl get pods -n expand-ns -l app=expand-app --no-headers | grep -q Running"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
