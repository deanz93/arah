#!/usr/bin/env bash
# Bootstrap a new EKS cluster with all required controllers and CRDs.
# Run once after `terraform apply` creates the cluster.
#
# Usage: ./scripts/setup-cluster.sh <staging|production>
set -euo pipefail

ENV=${1:-staging}
CLUSTER_NAME="arah-${ENV}"
AWS_REGION="ap-southeast-1"

echo "==> Bootstrapping cluster: ${CLUSTER_NAME}"

# ── 1. Configure kubectl ──────────────────────────────────────────────────────
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --region "${AWS_REGION}"

echo "==> kubectl context: $(kubectl config current-context)"

# ── 2. Namespace ──────────────────────────────────────────────────────────────
kubectl apply -f infra/k8s/namespace.yaml

# ── 3. StorageClasses ─────────────────────────────────────────────────────────
kubectl apply -f infra/k8s/storage/storageclass-gp3.yaml
kubectl apply -f infra/k8s/storage/storageclass-efs.yaml

# ── 4. EBS CSI Driver (needed for gp3 PVCs) ──────────────────────────────────
echo "==> Installing EBS CSI driver add-on"
aws eks create-addon \
  --cluster-name "${CLUSTER_NAME}" \
  --addon-name aws-ebs-csi-driver \
  --resolve-conflicts OVERWRITE \
  --region "${AWS_REGION}" || echo "EBS CSI add-on already installed — skipping"

# ── 5. EFS CSI Driver (needed for ReadOnlyMany PVCs — Valhalla tiles) ─────────
echo "==> Installing EFS CSI driver"
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/ 2>/dev/null || true
helm repo update
helm upgrade --install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
  --namespace kube-system \
  --set controller.serviceAccount.create=true \
  --wait

# ── 6. cert-manager ───────────────────────────────────────────────────────────
echo "==> Installing cert-manager"
helm repo add jetstack https://charts.jetstack.io 2>/dev/null || true
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.0 \
  --set installCRDs=true \
  --wait

# ── 7. nginx ingress controller ───────────────────────────────────────────────
echo "==> Installing nginx ingress controller"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 2>/dev/null || true
helm repo update
helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --values "infra/terraform/environments/${ENV}/helm-values/nginx-ingress.yaml" \
  --wait

# ── 8. kube-prometheus-stack ──────────────────────────────────────────────────
echo "==> Installing Prometheus + Grafana"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo update
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --version 61.7.0 \
  --values "infra/terraform/environments/${ENV}/helm-values/prometheus.yaml" \
  --wait --timeout 10m

# ── 9. Let's Encrypt ClusterIssuer ───────────────────────────────────────────
echo "==> Applying cert-manager ClusterIssuer"
kubectl apply -f infra/k8s/ingress/certificate.yaml

# ── 10. Print ALB hostname ────────────────────────────────────────────────────
echo ""
echo "==> Cluster bootstrap complete!"
echo ""
echo "Ingress LB hostname (set in Route53 / DNS):"
kubectl get svc -n ingress-nginx nginx-ingress-ingress-nginx-controller \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "(LB not ready yet — check in a few minutes)"
echo ""
echo "Next steps:"
echo "  1. Update Route53 CNAME for api.arah.my → above LB hostname"
echo "  2. Run: ./scripts/deploy.sh ${ENV} <image-tag>"
