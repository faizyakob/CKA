#!/bin/bash
# ============================================================
# Lab Setup - Question 17: TLS Configuration with nginx
# ============================================================
set -e

echo "[*] Creating namespace nginx-static..."
kubectl create namespace nginx-static --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Generating self-signed TLS certificate..."
mkdir -p /tmp/nginx-tls
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/nginx-tls/tls.key \
  -out /tmp/nginx-tls/tls.crt \
  -subj "/CN=ckaquestion.k8s.local/O=CKA-PREP" \
  -addext "subjectAltName=DNS:ckaquestion.k8s.local" 2>/dev/null

echo "[*] Creating TLS Secret..."
kubectl create secret tls nginx-tls-secret \
  --cert=/tmp/nginx-tls/tls.crt \
  --key=/tmp/nginx-tls/tls.key \
  -n nginx-static \
  --dry-run=client -o yaml | kubectl apply -f -

echo "[*] Creating nginx ConfigMap with TLSv1.2 + TLSv1.3..."
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: nginx-static
data:
  nginx.conf: |
    events {}
    http {
      server {
        listen 443 ssl;
        server_name ckaquestion.k8s.local;

        ssl_certificate     /etc/nginx/tls/tls.crt;
        ssl_certificate_key /etc/nginx/tls/tls.key;

        ssl_protocols TLSv1.2 TLSv1.3;

        location / {
          return 200 'CKA TLS Question OK\n';
          add_header Content-Type text/plain;
        }
      }
    }
EOF

echo "[*] Creating nginx Deployment..."
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-static
  namespace: nginx-static
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-static
  template:
    metadata:
      labels:
        app: nginx-static
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 443
        volumeMounts:
        - name: config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: tls
          mountPath: /etc/nginx/tls
          readOnly: true
      volumes:
      - name: config
        configMap:
          name: nginx-config
      - name: tls
        secret:
          secretName: nginx-tls-secret
EOF

echo "[*] Creating nginx Service..."
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: nginx-static
spec:
  selector:
    app: nginx-static
  ports:
  - port: 443
    targetPort: 443
EOF

echo "[*] Waiting for deployment to be ready..."
kubectl rollout status deployment/nginx-static -n nginx-static --timeout=90s

echo ""
echo "[*] Lab setup complete!"
echo ""
echo "    Service ClusterIP:"
kubectl get svc nginx-service -n nginx-static
echo ""
echo "[*] Current ConfigMap (shows TLSv1.2 TLSv1.3 — your job is to remove TLSv1.2):"
kubectl get configmap nginx-config -n nginx-static -o jsonpath='{.data.nginx\.conf}' | grep ssl_protocols
