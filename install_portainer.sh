#!/usr/bin/env bash
set -euo pipefail

PORTAINER_HTTPS_PORT=${PORTAINER_HTTPS_PORT:-9443}
PORTAINER_EDGE_PORT=${PORTAINER_EDGE_PORT:-8000}
PORTAINER_CONTAINER_NAME=${PORTAINER_CONTAINER_NAME:-portainer}
PORTAINER_IMAGE=${PORTAINER_IMAGE:-portainer/portainer-ce:latest}

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if command -v apt-get >/dev/null 2>&1; then
  PKG_MANAGER="apt-get"
elif command -v yum >/dev/null 2>&1; then
  PKG_MANAGER="yum"
elif command -v dnf >/dev/null 2>&1; then
  PKG_MANAGER="dnf"
else
  echo "Supported package manager not found (apt-get, yum, or dnf)." >&2
  exit 1
fi

ensure_download_tool() {
  if command -v curl >/dev/null 2>&1 || command -v wget >/dev/null 2>&1; then
    return
  fi

  echo "Installing curl so Docker can be downloaded..."
  case "$PKG_MANAGER" in
    apt-get)
      apt-get update
      apt-get install -y curl
      ;;
    yum|dnf)
      $PKG_MANAGER install -y curl
      ;;
  esac
}

install_docker() {
  if command -v docker >/dev/null 2>&1; then
    return
  fi

  ensure_download_tool

  echo "Installing Docker using the official convenience script..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://get.docker.com | sh
  else
    wget -qO- https://get.docker.com | sh
  fi

  systemctl enable --now docker
}

ensure_docker_running() {
  if ! systemctl is-active --quiet docker; then
    systemctl start docker
  fi
}

install_docker
ensure_docker_running

if docker ps -a --format '{{.Names}}' | grep -Fxq "$PORTAINER_CONTAINER_NAME"; then
  echo "Container $PORTAINER_CONTAINER_NAME already exists."
  if ! docker ps --format '{{.Names}}' | grep -Fxq "$PORTAINER_CONTAINER_NAME"; then
    echo "Starting existing Portainer container..."
    docker start "$PORTAINER_CONTAINER_NAME"
  fi
  exit 0
fi

echo "Creating Docker volume portainer_data (if missing)..."
docker volume create portainer_data >/dev/null

echo "Deploying Portainer..."
docker run -d \
  --name "$PORTAINER_CONTAINER_NAME" \
  --restart=always \
  -p "${PORTAINER_EDGE_PORT}:8000" \
  -p "${PORTAINER_HTTPS_PORT}:9443" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  "$PORTAINER_IMAGE"

cat <<INFO
Portainer is running.
  HTTPS UI: https://<server-ip>:${PORTAINER_HTTPS_PORT}
  Edge agent port: ${PORTAINER_EDGE_PORT}
INFO
