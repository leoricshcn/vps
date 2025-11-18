#!/usr/bin/env bash
set -euo pipefail

DOMAIN=${DOMAIN:-}
TARGET=${TARGET:-http://127.0.0.1:3000}
LISTEN_PORT=${LISTEN_PORT:-80}

if [[ -z "$DOMAIN" ]]; then
  read -rp "Enter the domain name to configure for Nginx: " DOMAIN || true
fi

if [[ -z "$DOMAIN" ]]; then
  echo "Domain name is required. Set DOMAIN env var or provide input." >&2
  exit 1
fi

if [[ -z "$TARGET" ]]; then
  echo "TARGET (upstream URL) is required." >&2
  exit 1
fi

PKG_MANAGER=""
INSTALL_CMD=""
if command -v apt-get >/dev/null 2>&1; then
  PKG_MANAGER="apt"
  INSTALL_CMD="apt-get install -y"
  apt-get update
elif command -v yum >/dev/null 2>&1; then
  PKG_MANAGER="yum"
  INSTALL_CMD="yum install -y"
  yum makecache --quiet
else
  echo "Supported package manager not found (apt or yum)." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "Installing curl"
  eval "$INSTALL_CMD curl"
fi

echo "Installing nginx via $PKG_MANAGER"
eval "$INSTALL_CMD nginx"

if [[ $PKG_MANAGER == "apt" ]]; then
  systemctl enable nginx >/dev/null 2>&1 || true
  NGX_CONF_DIR="/etc/nginx/sites-available"
  ENABLED_DIR="/etc/nginx/sites-enabled"
  mkdir -p "$NGX_CONF_DIR" "$ENABLED_DIR"
  CONF_FILE="$NGX_CONF_DIR/${DOMAIN}.conf"
  ln -sf "$CONF_FILE" "$ENABLED_DIR/${DOMAIN}.conf"
else
  systemctl enable nginx >/dev/null 2>&1 || true
  NGX_CONF_DIR="/etc/nginx/conf.d"
  mkdir -p "$NGX_CONF_DIR"
  CONF_FILE="$NGX_CONF_DIR/${DOMAIN}.conf"
fi

cat >"$CONF_FILE" <<NGINX_CONF
server {
    listen ${LISTEN_PORT} default_server;
    listen [::]:${LISTEN_PORT} default_server;
    server_name ${DOMAIN};

    location / {
        proxy_pass ${TARGET};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
NGINX_CONF

nginx -t
systemctl restart nginx

echo "Nginx reverse proxy configured for ${DOMAIN} -> ${TARGET}"
