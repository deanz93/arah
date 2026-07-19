# Arah — Kubernetes Deployment

## Prerequisites

- `kubectl` configured against your EKS cluster
- `helm` v3+
- AWS EKS cluster (ap-southeast-1, min 3 nodes)
- AWS EFS CSI driver installed (for shared tile storage)
- cert-manager installed

## Deploy Order

```bash
# 1. Create namespace
kubectl apply -f namespace.yaml

# 2. Create secrets (fill in real values first)
# DO NOT use secrets-template.yaml directly — create via CLI:
kubectl create secret generic firebase-secrets \
  --namespace=arah \
  --from-literal=project-id=arah-app \
  --from-literal=client-email=YOUR_EMAIL \
  --from-literal=private-key="$(cat private-key.pem)"

kubectl create secret generic app-secrets \
  --namespace=arah \
  --from-literal=hmac-secret=$(openssl rand -hex 32) \
  --from-literal=redis-url=redis://redis:6379 \
  --from-literal=nominatim-password=$(openssl rand -hex 16)

# 3. Deploy Redis first (others depend on it)
kubectl apply -f redis/

# 4. Deploy storage-dependent services
kubectl apply -f valhalla/pvc.yaml
kubectl apply -f nominatim/pvc.yaml
kubectl apply -f tile-server/deployment.yaml

# 5. Wait for PVCs to bind
kubectl wait --for=condition=Bound pvc --all -n arah --timeout=120s

# 6. Deploy services
kubectl apply -f valhalla/
kubectl apply -f nominatim/
kubectl apply -f tile-server/

# 7. Deploy API Gateway
kubectl apply -f api-gateway/

# 8. Deploy ingress + TLS
kubectl apply -f ingress/certificate.yaml
kubectl apply -f ingress/ingress.yaml

# 9. Deploy monitoring
kubectl apply -f monitoring/
```

## Check Status

```bash
kubectl get pods -n arah
kubectl get hpa -n arah
kubectl get ingress -n arah
kubectl get certificates -n arah
```

## Scale Manually (if HPA isn't sufficient)

```bash
# Scale API Gateway to 5 replicas
kubectl scale deployment api-gateway --replicas=5 -n arah

# Scale Valhalla to 5 replicas (watch RAM on nodes)
kubectl scale deployment valhalla --replicas=5 -n arah
```

## Node Pool Recommendation (AWS EKS)

| Node Pool | Instance | Count | For |
|-----------|----------|-------|-----|
| `general` | m5.large | 2–4 | API Gateway, Redis, Tile Server |
| `memory-optimized` | r6i.xlarge | 2–4 | Valhalla (4GB RAM per pod) |
| `compute` | m5.xlarge | 1–2 | Nominatim |

Label nodes:
```bash
kubectl label node <node-name> node-type=memory-optimized
```
