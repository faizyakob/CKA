#!/bin/bash
# ============================================================
# Validate - Question 11: DaemonSets
# ============================================================
PASS=0
FAIL=0

check() {
  local desc="$1"
  local cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "  [PASS] $desc"
    ((PASS++))
  else
    echo "  [FAIL] $desc"
    ((FAIL++))
  fi
}

echo "======================================"
echo " Validating Question 11"
echo "======================================"

check "DaemonSet 'log-agent' exists in monitoring" \
  "kubectl get daemonset log-agent -n monitoring"

check "DaemonSet uses image fluentd:v1.16" \
  "kubectl get daemonset log-agent -n monitoring -o jsonpath='{.spec.template.spec.containers[0].image}' | grep -q 'fluentd:v1.16'"

check "DaemonSet has label app=log-agent" \
  "kubectl get daemonset log-agent -n monitoring -o jsonpath='{.metadata.labels.app}' | grep -q log-agent"

DESIRED=$(kubectl get daemonset log-agent -n monitoring -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null)
READY=$(kubectl get daemonset log-agent -n monitoring -o jsonpath='{.status.numberReady}' 2>/dev/null)

check "All desired DaemonSet pods are ready ($READY/$DESIRED)" \
  "[ '$DESIRED' = '$READY' ] && [ -n '$DESIRED' ]"

check "/var/log is mounted read-only in container" \
  "kubectl get daemonset log-agent -n monitoring -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[0].readOnly}' | grep -q true"

check "hostPath /var/log is configured" \
  "kubectl get daemonset log-agent -n monitoring -o jsonpath='{.spec.template.spec.volumes[0].hostPath.path}' | grep -q /var/log"

echo "======================================"
echo " Results: $PASS passed, $FAIL failed"
echo "======================================"
