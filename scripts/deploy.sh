#!/usr/bin/env bash
# Deploy a specific image tag to an environment.
# Usage: ./scripts/deploy.sh <staging|production> <image-tag>
#
# Example: ./scripts/deploy.sh staging develop-abc12345
#          ./scripts/deploy.sh production v1.2.3
set -euo pipefail

ENV=${1:?Usage: $0 <staging|production> <image-tag>}
TAG=${2:?Usage: $0 <staging|production> <image-tag>}

CLUSTER_NAME="arah-${ENV}"
AWS_REGION="ap-southeast-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
OVERLAY="infra/k8s/overlays/${ENV}"

echo "==> Deploying tag [${TAG}] to [${ENV}]"

# ── Verify images exist ───────────────────────────────────────────────────────
for svc in api-gateway tile-server web; do
  echo -n "  Checking ${svc}:${TAG} ... "
  aws ecr describe-images \
    --repository-name "arah/${svc}" \
    --image-ids "imageTag=${TAG}" \
    --region "${AWS_REGION}" \
    --query 'imageDetails[0].imagePushedAt' \
    --output text 2>/dev/null || { echo "MISSING"; exit 1; }
  echo "OK"
done

# ── Configure kubectl ─────────────────────────────────────────────────────────
aws eks update-kubeconfig --name "${CLUSTER_NAME}" --region "${AWS_REGION}"

# ── Update Kustomize overlay ──────────────────────────────────────────────────
kustomize edit set image \
  "api-gateway=${ECR_REGISTRY}/arah/api-gateway:${TAG}" \
  "tile-server=${ECR_REGISTRY}/arah/tile-server:${TAG}" \
  "web=${ECR_REGISTRY}/arah/web:${TAG}" \
  --kustomization "${OVERLAY}/kustomization.yaml"

# ── Apply ─────────────────────────────────────────────────────────────────────
echo "==> Applying Kustomize overlay: ${OVERLAY}"
kustomize build "${OVERLAY}" | kubectl apply -f -

# ── Wait for rollout ──────────────────────────────────────────────────────────
echo "==> Waiting for rollouts ..."
kubectl rollout status deployment/api-gateway -n arah --timeout=10m
kubectl rollout status deployment/tile-server -n arah --timeout=10m

# ── Smoke test ────────────────────────────────────────────────────────────────
if [[ "${ENV}" == "production" ]]; then
  HEALTH_URL="https://api.arah.my/health"
else
  LB=$(kubectl get svc -n ingress-nginx nginx-ingress-ingress-nginx-controller \
    -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  HEALTH_URL="http://${LB}/health"
fi

echo "==> Smoke test: ${HEALTH_URL}"
sleep 5
curl -sf "${HEALTH_URL}" | grep '"status":"ok"' && echo "PASS" || { echo "FAIL — rolling back"; bash "$(dirname "$0")/rollback.sh" "${ENV}"; exit 1; }

echo ""
echo "==> Deploy [${TAG}] to [${ENV}] complete"
