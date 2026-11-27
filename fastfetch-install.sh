#!/bin/sh
set -eu
umask 022

case "$(uname -m)" in
  x86_64) ARCH="amd64" ;;
  aarch64) ARCH="aarch64" ;;
  *) echo "Error: unsupported architecture $(uname -m)" >&2; exit 1 ;;
esac

ASSET="fastfetch-linux-$ARCH.tar.gz"
API_URL="https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest"
DOWNLOAD_URL="https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-$ARCH.tar.gz"
BIN_PATH="/opt/bin/fastfetch"

# Everything fastfetch puts under `/opt` must belong to root (the release tarball is owned by uid 1001).
# Runs on every call, so an install made by an older version of this script gets repaired too.
fix_owner() {
for p in /opt/bin /opt/share; do
  if [ -d "$p" ]; then chown root:root "$p"; fi
done
for p in /opt/bin/fastfetch /opt/bin/flashfetch /opt/share/fastfetch /opt/share/man /opt/share/licenses /opt/share/bash-completion /opt/share/fish /opt/share/zsh; do
  if [ -e "$p" ]; then chown -R root:root "$p"; fi
done
}

# Fetch latest release tag without requiring jq
LATEST_VER=$(curl -fsSL -H "Accept: application/vnd.github+json" "$API_URL" \
  | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  | head -n 1 \
  | sed 's/^v//')

if [ -z "$LATEST_VER" ]; then
  echo "Error: Could not retrieve the latest version from GitHub." >&2
  exit 1
fi

# Get currently installed version (if present)
if [ -x "$BIN_PATH" ]; then
  CURRENT_VER=$("$BIN_PATH" --version | awk '{print $2}')
else
  CURRENT_VER="none"
fi

if [ "$CURRENT_VER" = "$LATEST_VER" ]; then
  fix_owner
  echo "fastfetch is already up to date ($CURRENT_VER). Skipping download."
  exit 0
fi

echo "Updating fastfetch: $CURRENT_VER -> $LATEST_VER"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/fastfetch.tar.gz"
tar -xzf "$TMP_DIR/fastfetch.tar.gz" -C "$TMP_DIR"

mkdir -p /opt/bin /opt/share
cp -a "$TMP_DIR/fastfetch-linux-amd64/usr/bin/." /opt/bin/
cp -a "$TMP_DIR/fastfetch-linux-amd64/usr/share/." /opt/share/
fix_owner
chmod +x "$BIN_PATH"

echo "Successfully installed: $("$BIN_PATH" --version)"
