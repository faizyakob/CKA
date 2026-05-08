#!/bin/bash
set -e
echo "[*] Creating namespace ingress-debug-ns..."
kubectl create namespace ingress-debug-ns --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating deployment and service (port 80)..."
kubectl create deployment debug-app --image=nginx:1.25 \
  -n ingress-debug-ns --dry-run=client -o yaml | kubectl apply -f -

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: debug-app-svc
  namespace: ingress-debug-ns
spec:
  selector:
    app: debug-app
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl rollout status deployment/debug-app -n ingress-debug-ns --timeout=60s

echo "[*] Creating Ingress with WRONG service port (9999 instead of 80)..."
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: broken-ingress
  namespace: ingress-debug-ns
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: debug-app-svc
            port:
              number: 9999
EOF

echo ""
echo "[*] Lab is ready."
echo "    Ingress routes to port 9999 but the Service listens on port 80."
echo "    This causes 503 Service Unavailable."
echo ""
echo "    Investigate: kubectl describe ingress broken-ingress -n ingress-debug-ns"
echo "    Fix the Ingress backend port."
