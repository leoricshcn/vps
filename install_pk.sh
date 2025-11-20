#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <source-key-path> <target-key-name>" >&2
  exit 1
fi

SOURCE_KEY="$1"
TARGET_NAME="$2"

if [[ ! -f "$SOURCE_KEY" ]]; then
  echo "Source key does not exist: $SOURCE_KEY" >&2
  exit 1
fi

if [[ ! -s "$SOURCE_KEY" ]]; then
  echo "Source key is empty: $SOURCE_KEY" >&2
  exit 1
fi

SSH_DIR="$HOME/.ssh"
TARGET_KEY="$SSH_DIR/$TARGET_NAME"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [[ -f "$TARGET_KEY" ]]; then
  echo "Refusing to overwrite existing key: $TARGET_KEY" >&2
  exit 1
fi

install -m 600 "$SOURCE_KEY" "$TARGET_KEY"
echo "Private key installed at $TARGET_KEY"
