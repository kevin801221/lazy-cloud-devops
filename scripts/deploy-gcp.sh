#!/usr/bin/env bash
# ===========================================================================
# deploy-gcp.sh — Ponytail-grade deploy to Google Cloud Run
# ---------------------------------------------------------------------------
# Builds a lean multi-stage container, asserts it is actually minimal, and
# ships it to Cloud Run with scale-to-zero and least-privilege defaults.
#
# Usage:
#   ./scripts/deploy-gcp.sh <service-name> [region]
#
# Env (override as needed):
#   GCP_PROJECT     GCP project id            (default: gcloud's active project)
#   GCP_REGION      Cloud Run region          (default: asia-east1)
#   MAX_IMAGE_MB    Fail if image exceeds MB  (default: 300)
#   MIN_INSTANCES   Min instances (0 = s2z)   (default: 0)
#   MAX_INSTANCES   Max instances             (default: 4)
#   MEMORY          Per-instance memory       (default: 256Mi)
#   ALLOW_UNAUTH    Public service?           (default: true)
# ===========================================================================
set -Eeuo pipefail

# ---- pretty, dependency-free logging --------------------------------------
log()  { printf '\033[1;34m🦥 [lazy-gcp]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }
trap 'die "failed at line $LINENO"' ERR

# ---- inputs ---------------------------------------------------------------
SERVICE="${1:-}"
[[ -n "$SERVICE" ]] || die "usage: $0 <service-name> [region]"

REGION="${2:-${GCP_REGION:-asia-east1}}"
PROJECT="${GCP_PROJECT:-$(gcloud config get-value project 2>/dev/null || true)}"
[[ -n "$PROJECT" && "$PROJECT" != "(unset)" ]] || die "no GCP project set (export GCP_PROJECT or run: gcloud config set project ...)"

MAX_IMAGE_MB="${MAX_IMAGE_MB:-300}"
MIN_INSTANCES="${MIN_INSTANCES:-0}"
MAX_INSTANCES="${MAX_INSTANCES:-4}"
MEMORY="${MEMORY:-256Mi}"
ALLOW_UNAUTH="${ALLOW_UNAUTH:-true}"

IMAGE="${REGION}-docker.pkg.dev/${PROJECT}/lazy-cloud/${SERVICE}:$(git rev-parse --short HEAD 2>/dev/null || echo latest)"

# ---- 0. preflight ---------------------------------------------------------
command -v gcloud >/dev/null || die "gcloud not installed"
command -v docker >/dev/null || die "docker not installed"
[[ -f Dockerfile ]] || die "no Dockerfile found — Ponytail rule §4 requires a multi-stage Alpine build"

log "project=$PROJECT  region=$REGION  service=$SERVICE"

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
(( SIZE_MB <= MAX_IMAGE_MB )) || die "image ${SIZE_MB}MB exceeds ${MAX_IMAGE_MB}MB gate — strip slop (multi-stage prune, smaller base) and retry"
ok "footprint within budget"

# ---- 4. ensure registry + push --------------------------------------------
log "ensuring Artifact Registry + enabling required APIs..."
gcloud services enable run.googleapis.com artifactregistry.googleapis.com --project "$PROJECT" --quiet
gcloud artifacts repositories describe lazy-cloud --location "$REGION" --project "$PROJECT" >/dev/null 2>&1 \
  || gcloud artifacts repositories create lazy-cloud \
       --repository-format=docker --location "$REGION" --project "$PROJECT" --quiet
gcloud auth configure-docker "${REGION}-docker.pkg.dev" --quiet
docker push "$IMAGE"
ok "image pushed"

# ---- 5. deploy to Cloud Run (scale-to-zero, right-sized) ------------------
AUTH_FLAG="--no-allow-unauthenticated"
[[ "$ALLOW_UNAUTH" == "true" ]] && AUTH_FLAG="--allow-unauthenticated"

log "deploying to Cloud Run..."
gcloud run deploy "$SERVICE" \
  --image "$IMAGE" \
  --project "$PROJECT" \
  --region "$REGION" \
  --platform managed \
  --memory "$MEMORY" \
  --cpu 1 \
  --min-instances "$MIN_INSTANCES" \
  --max-instances "$MAX_INSTANCES" \
  --port 8080 \
  --no-cpu-throttling \
  $AUTH_FLAG \
  --quiet

URL="$(gcloud run services describe "$SERVICE" --region "$REGION" --project "$PROJECT" --format 'value(status.url)')"

# ---- 6. report ------------------------------------------------------------
printf '\n'
ok "DEPLOYED — Ponytail clean ✨"
printf '   service : %s\n' "$SERVICE"
printf '   image   : %s (%s MB)\n' "$IMAGE" "$SIZE_MB"
printf '   region  : %s  (min=%s max=%s mem=%s)\n' "$REGION" "$MIN_INSTANCES" "$MAX_INSTANCES" "$MEMORY"
printf '   url     : \033[1;36m%s\033[0m\n\n' "$URL"
