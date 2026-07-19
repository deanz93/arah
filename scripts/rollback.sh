#!/usr/bin/env bash
# Roll back all deployments in an environment to the previous revision.
# Usage: ./scripts/rollback.sh <staging|production>
set -euo pipefail

ENV=${1:?Usage: $0 <staging|production>}
CLUSTER_NAME="arah-${ENV}"
AWS_REGION="ap-southeast-1"

echo "==> Rolling back [${ENV}] ..."

aws eks update-kubeconfig --name "${CLUSTER_NAME}" --region "${AWS_REGION}"

for deploy in api-gateway tile-server; do
  echo "  Rolling back deployment/${deploy}"
  kubectl rollout undo "deployment/${deploy}" -n arah
  kubectl rollout status "deployment/${deploy}" -n arah --timeout=5m
done

echo ""
echo "==> Rollback complete. Current pod state:"
kubectl get pods -n arah -o wide
