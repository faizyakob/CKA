#!/bin/bash
PASS=0; FAIL=0
check() {
  if eval "$2" &>/dev/null; then echo "  [PASS] $1"; ((PASS++))
  else echo "  [FAIL] $1"; ((FAIL++)); fi
}
echo "======================================"; echo " Validating Question 13"; echo "======================================"

check "CoreDNS ConfigMap does NOT have broken upstream (1.2.3.4)" \
  "! kubectl get configmap coredns -n kube-system -o jsonpath='{.data.Corefile}' | grep -q '1\.2\.3\.4'"

check "CoreDNS ConfigMap forward points to /etc/resolv.conf" \
  "kubectl get configmap coredns -n kube-system -o jsonpath='{.data.Corefile}' | grep -q '/etc/resolv.conf'"

check "CoreDNS deployment is available" \
  "kubectl rollout status deployment/coredns -n kube-system --timeout=30s"

check "CoreDNS pods are Running" \
  "kubectl get pods -n kube-system -l k8s-app=kube-dns --no-headers | grep -q Running"

check "DNS resolves kubernetes.default" \
  "kubectl run dns-val --image=busybox:1.35 --restart=Never --rm \
    --command -- nslookup kubernetes.default 2>/dev/null | grep -q Address"

echo "======================================"; echo " Results: $PASS passed, $FAIL failed"; echo "======================================"
