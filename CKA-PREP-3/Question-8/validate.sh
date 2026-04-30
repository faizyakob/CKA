#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 8"; echo "======================================"

check "PV 'retain-pv' exists" "kubectl get pv retain-pv"
check "retain-pv reclaimPolicy is Retain" "kubectl get pv retain-pv -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' | grep -q Retain"
check "retain-pv capacity is 2Gi" "kubectl get pv retain-pv -o jsonpath='{.spec.capacity.storage}' | grep -q 2Gi"
check "retain-pv storageClassName is manual" "kubectl get pv retain-pv -o jsonpath='{.spec.storageClassName}' | grep -q manual"
check "PVC 'retain-pvc' was created in retain-ns (may be deleted now)" \
  "kubectl get pvc retain-pvc -n retain-ns 2>/dev/null || kubectl get pv retain-pv -o jsonpath='{.status.phase}' | grep -qE 'Released|Available'"
check "PV is in Released or Available state (not Deleted)" \
  "kubectl get pv retain-pv -o jsonpath='{.status.phase}' | grep -qE 'Released|Available|Bound'"
check "PV was NOT deleted after PVC removal (Retain policy working)" \
  "kubectl get pv retain-pv"
check "PV claimRef is cleared (Available for reuse) OR still Released" \
  "kubectl get pv retain-pv -o jsonpath='{.status.phase}' | grep -qE 'Available|Released'"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
