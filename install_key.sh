#!/usr/bin/env bash
set -euo pipefail

PUB_KEY_FILE="$(dirname "$0")/id_ed25519.pub"

echo "Installing SSH public key from ${PUB_KEY_FILE}" 

if [[ ! -f "$PUB_KEY_FILE" ]]; then
  echo "Public key file not found: $PUB_KEY_FILE" >&2
  exit 1
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
AUTHORIZED_KEYS="$HOME/.ssh/authorized_keys"

touch "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"

if grep -qxF "$(cat "$PUB_KEY_FILE")" "$AUTHORIZED_KEYS"; then
  echo "Key already present in $AUTHORIZED_KEYS"
else
  cat "$PUB_KEY_FILE" >> "$AUTHORIZED_KEYS"
  echo "Key installed to $AUTHORIZED_KEYS"
fi
