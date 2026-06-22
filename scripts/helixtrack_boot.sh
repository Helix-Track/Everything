#!/usr/bin/env bash
# =============================================================================
# HelixTrack Container Boot
# -----------------------------------------------------------------------------
# Purpose: Boot HelixTrack Core in a container using the helix_track repo's own
#          containers/ submodule compose infrastructure. Shows loading progress.
# Usage:   scripts/helixtrack_boot.sh [--space-dir=<path>]
#
# Relocated 2026-06-22 from the project-agnostic vasic-digital/containers submodule
# to the helix_track repo (CONST-051(B) decoupling). This script lives at
# helix_track/scripts/, so the repo root is one level up; the compose file lives at
# the helix_track repo root and the container infra is the helix_track containers/
# submodule.
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONTAINERS_DIR="${HT_ROOT}/containers"
COMPOSE_FILE="${HT_ROOT}/compose.helixtrack.yml"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

log_info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
log_step()  { echo -e "${YELLOW}[STEP]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     HelixTrack Container Boot                   ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Check compose file
if [ ! -f "$COMPOSE_FILE" ]; then
    log_error "Compose file not found: ${COMPOSE_FILE}"
    exit 1
fi

# Check docker
if ! command -v docker &>/dev/null; then
    log_error "Docker is required but not found"
    exit 1
fi

log_step "Checking HelixTrack Core Dockerfile..."
if [ ! -f "${HT_ROOT}/core/Application/Dockerfile" ]; then
    log_info "No Dockerfile found — creating default..."
    mkdir -p "${HT_ROOT}/core/Application"
    cat > "${HT_ROOT}/core/Application/Dockerfile" <<'DOCKERFILE'
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o htCore main.go

FROM alpine:3.19
RUN apk --no-cache add curl ca-certificates
WORKDIR /app
COPY --from=builder /app/htCore .
COPY --from=builder /app/Configurations ./Configurations
COPY --from=builder /app/Database ./Database
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD curl -f http://localhost:8080/health || exit 1
ENTRYPOINT ["./htCore"]
DOCKERFILE
    log_ok "Default Dockerfile created"
fi

log_step "Building HelixTrack Core..."
docker compose -f "$COMPOSE_FILE" build helixtrack-core 2>&1 | tail -5
log_ok "Build complete"

log_step "Starting HelixTrack Core..."
docker compose -f "$COMPOSE_FILE" up -d helixtrack-core 2>&1 | tail -3

# Wait for readiness
log_info "Waiting for HelixTrack Core to become ready..."
for i in $(seq 1 30); do
    if curl -sf "http://localhost:8080/health" &>/dev/null; then
        echo ""
        log_ok "HelixTrack Core is ready on http://localhost:8080 (${i}s)"
        log_info "Container: helixtrack-core"
        log_info "Space: ${HT_ROOT}/spaces/_default"
        echo ""
        exit 0
    fi
    sleep 1
done

echo ""
log_error "HelixTrack Core did not become ready within 30s"
log_info "Check logs: docker logs helixtrack-core"
exit 1
