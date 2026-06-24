#!/usr/bin/env bash
# ===========================================================================
# deploy-aws.sh — Ponytail-grade deploy to AWS ECS Fargate
# ---------------------------------------------------------------------------
# Builds a lean multi-stage container, asserts it is actually minimal, pushes
# to ECR, and rolls it out to ECS Fargate with right-sized, least-privilege
# defaults. Idempotent: creates the cluster/service on first run, updates after.
#
# Usage:
#   ./scripts/deploy-aws.sh <service-name> [region]
#
# Env (override as needed):
#   AWS_REGION       AWS region              (default: ap-northeast-1)
#   AWS_ACCOUNT_ID   Account id              (default: from STS)
#   CLUSTER          ECS cluster name        (default: lazy-cloud)
#   MAX_IMAGE_MB     Fail if image > MB      (default: 300)
#   CPU              Task CPU units          (default: 256)
#   MEMORY           Task memory (MiB)       (default: 512)
#   DESIRED_COUNT    Running tasks           (default: 1)
#   CONTAINER_PORT   App port                (default: 8080)
#   EXEC_ROLE_ARN    Task execution role ARN (required for first create)
#   SUBNETS          comma-sep subnet ids    (required for first create)
#   SECURITY_GROUPS  comma-sep sg ids        (required for first create)
# ===========================================================================
set -Eeuo pipefail

log()  { printf '\033[1;34m🦥 [lazy-aws]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }
trap 'die "failed at line $LINENO"' ERR

# ---- inputs ---------------------------------------------------------------
SERVICE="${1:-}"
[[ -n "$SERVICE" ]] || die "usage: $0 <service-name> [region]"

REGION="${2:-${AWS_REGION:-ap-northeast-1}}"
CLUSTER="${CLUSTER:-lazy-cloud}"
MAX_IMAGE_MB="${MAX_IMAGE_MB:-300}"
CPU="${CPU:-256}"
MEMORY="${MEMORY:-512}"
DESIRED_COUNT="${DESIRED_COUNT:-1}"
CONTAINER_PORT="${CONTAINER_PORT:-8080}"

# ---- 0. preflight ---------------------------------------------------------
command -v aws    >/dev/null || die "aws cli not installed"
command -v docker >/dev/null || die "docker not installed"
[[ -f Dockerfile ]] || die "no Dockerfile found — Ponytail rule §4 requires a multi-stage Alpine build"

ACCOUNT_ID="${AWS_ACCOUNT_ID:-$(aws sts get-caller-identity --query Account --output text)}"
[[ -n "$ACCOUNT_ID" ]] || die "could not resolve AWS account id (configure credentials)"

TAG="$(git rev-parse --short HEAD 2>/dev/null || echo latest)"
REGISTRY="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
IMAGE="${REGISTRY}/${SERVICE}:${TAG}"

log "account=$ACCOUNT_ID  region=$REGION  cluster=$CLUSTER  service=$SERVICE"

# ---- 1. slop guard: enforce a lean Dockerfile -----------------------------
log "auditing Dockerfile for slop..."
grep -qiE 'FROM .* AS ' Dockerfile || die "Dockerfile is not multi-stage (Ponytail §4.2)"
grep -qiE 'alpine|-slim|distroless' Dockerfile || warn "base image is not Alpine/slim/distroless — footprint will be heavy"
grep -qiE '^[[:space:]]*USER ' Dockerfile || warn "no non-root USER directive — running as root (Ponytail §4.2)"
grep -qiE ':latest' Dockerfile && warn "unpinned ':latest' base tag detected — pin your versions"
[[ -f .dockerignore ]] || warn "no .dockerignore — build context may leak/secrets/bloat layers"
ok "Dockerfile audit complete"

# ---- 2. build the lean image ----------------------------------------------
log "building image: $IMAGE"
docker build --pull -t "$IMAGE" .
ok "image built"

# ---- 3. assert minimalism (footprint gate) --------------------------------
SIZE_BYTES="$(docker image inspect "$IMAGE" --format '{{.Size}}')"
SIZE_MB=$(( SIZE_BYTES / 1024 / 1024 ))
log "final image size: ${SIZE_MB} MB (gate: ${MAX_IMAGE_MB} MB)"
(( SIZE_MB <= MAX_IMAGE_MB )) || die "image ${SIZE_MB}MB exceeds ${MAX_IMAGE_MB}MB gate — strip slop and retry"
ok "footprint within budget"

# ---- 4. ensure ECR repo + push --------------------------------------------
log "ensuring ECR repository + login..."
aws ecr describe-repositories --repository-names "$SERVICE" --region "$REGION" >/dev/null 2>&1 \
  || aws ecr create-repository --repository-name "$SERVICE" --region "$REGION" \
       --image-scanning-configuration scanOnPush=true >/dev/null
aws ecr get-login-password --region "$REGION" \
  | docker login --username AWS --password-stdin "$REGISTRY" >/dev/null
docker push "$IMAGE"
ok "image pushed"

# ---- 5. register a right-sized Fargate task definition --------------------
log "registering task definition..."
EXEC_ROLE_ARN="${EXEC_ROLE_ARN:-arn:aws:iam::${ACCOUNT_ID}:role/ecsTaskExecutionRole}"
LOG_GROUP="/ecs/${SERVICE}"
aws logs create-log-group --log-group-name "$LOG_GROUP" --region "$REGION" >/dev/null 2>&1 || true

TASKDEF_JSON="$(cat <<JSON
{
  "family": "${SERVICE}",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "${CPU}",
  "memory": "${MEMORY}",
  "executionRoleArn": "${EXEC_ROLE_ARN}",
  "containerDefinitions": [
    {
      "name": "${SERVICE}",
      "image": "${IMAGE}",
      "essential": true,
      "portMappings": [{ "containerPort": ${CONTAINER_PORT}, "protocol": "tcp" }],
      "readonlyRootFilesystem": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${LOG_GROUP}",
          "awslogs-region": "${REGION}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
JSON
)"

TASKDEF_ARN="$(aws ecs register-task-definition \
  --region "$REGION" \
  --cli-input-json "$TASKDEF_JSON" \
  --query 'taskDefinition.taskDefinitionArn' --output text)"
ok "task definition: $TASKDEF_ARN"

# ---- 6. create-or-update the ECS service ----------------------------------
aws ecs describe-clusters --clusters "$CLUSTER" --region "$REGION" \
  --query 'clusters[0].status' --output text 2>/dev/null | grep -q ACTIVE \
  || aws ecs create-cluster --cluster-name "$CLUSTER" --region "$REGION" >/dev/null

SERVICE_EXISTS="$(aws ecs describe-services --cluster "$CLUSTER" --services "$SERVICE" \
  --region "$REGION" --query 'services[0].status' --output text 2>/dev/null || echo NONE)"

if [[ "$SERVICE_EXISTS" == "ACTIVE" ]]; then
  log "updating existing ECS service (rolling deploy)..."
  aws ecs update-service \
    --cluster "$CLUSTER" --service "$SERVICE" \
    --task-definition "$TASKDEF_ARN" \
    --desired-count "$DESIRED_COUNT" \
    --region "$REGION" >/dev/null
else
  log "creating ECS service (first deploy)..."
  [[ -n "${SUBNETS:-}" && -n "${SECURITY_GROUPS:-}" ]] \
    || die "first create needs SUBNETS and SECURITY_GROUPS env vars (comma-separated)"
  NET_CONFIG="awsvpcConfiguration={subnets=[${SUBNETS}],securityGroups=[${SECURITY_GROUPS}],assignPublicIp=ENABLED}"
  aws ecs create-service \
    --cluster "$CLUSTER" --service-name "$SERVICE" \
    --task-definition "$TASKDEF_ARN" \
    --desired-count "$DESIRED_COUNT" \
    --launch-type FARGATE \
    --network-configuration "$NET_CONFIG" \
    --region "$REGION" >/dev/null
fi

log "waiting for service to stabilize..."
aws ecs wait services-stable --cluster "$CLUSTER" --services "$SERVICE" --region "$REGION"

# ---- 7. report ------------------------------------------------------------
printf '\n'
ok "DEPLOYED — Ponytail clean ✨"
printf '   service : %s\n' "$SERVICE"
printf '   image   : %s (%s MB)\n' "$IMAGE" "$SIZE_MB"
printf '   cluster : %s  (cpu=%s mem=%s count=%s)\n' "$CLUSTER" "$CPU" "$MEMORY" "$DESIRED_COUNT"
printf '   taskdef : %s\n\n' "$TASKDEF_ARN"
