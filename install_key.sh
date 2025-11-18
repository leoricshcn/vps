#!/usr/bin/env bash
set -euo pipefail

KEY_URL=${KEY_URL:-"https://raw.githubusercontent.com/leoricshcn/vps/main/id_ed25519.pub"}
TMP_KEY_FILE="$(mktemp)"
trap 'rm -f "$TMP_KEY_FILE"' EXIT

echo "Downloading SSH public key from ${KEY_URL}"
if ! curl -fsSL "$KEY_URL" -o "$TMP_KEY_FILE"; then
  echo "Failed to download public key from $KEY_URL" >&2
  exit 1
fi

if [[ ! -s "$TMP_KEY_FILE" ]]; then
  echo "Downloaded key file is empty: $KEY_URL" >&2
  exit 1
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
AUTHORIZED_KEYS="$HOME/.ssh/authorized_keys"

touch "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"

KEY_CONTENT="$(<"$TMP_KEY_FILE")"

if grep -qxF "$KEY_CONTENT" "$AUTHORIZED_KEYS"; then
  echo "Key already present in $AUTHORIZED_KEYS"
else
  printf '%s\n' "$KEY_CONTENT" >> "$AUTHORIZED_KEYS"
  echo "Key installed to $AUTHORIZED_KEYS"
fi
