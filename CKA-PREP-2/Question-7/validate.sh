#!/bin/bash
# ============================================================
# Validate - Question 7: Pod Disruption Budget
# ============================================================
PASS=0; FAIL=0

check() {
  local desc="$1"; local cmd="$2"
  if eval "$cmd" &>/dev/null; then echo "  [PASS] $desc"; ((PASS++))
  else echo "  [FAIL] $desc"; ((FAIL++)); fi
}

echo "======================================"
echo " Validating Question 7"
echo "======================================"

check "PDB 'critical-pdb' exists in pdb-ns" \
  "kubectl get pdb critical-pdb -n pdb-ns"

check "PDB minAvailable is 3" \
  "kubectl get pdb critical-pdb -n pdb-ns -o jsonpath='{.spec.minAvailable}' | grep -q 3"

check "PDB selector matches app=critical" \
  "kubectl get pdb critical-pdb -n pdb-ns -o jsonpath='{.spec.selector.matchLabels.app}' | grep -q critical"

check "Deployment 'critical-app' has 4 replicas ready" \
  "[ \$(kubectl get deployment critical-app -n pdb-ns -o jsonpath='{.status.readyReplicas}') -eq 4 ]"

check "PDB shows 1 allowed disruption" \
  "kubectl get pdb critical-pdb -n pdb-ns -o jsonpath='{.status.disruptionsAllowed}' | grep -q 1"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
