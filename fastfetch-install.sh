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

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Fetch release metadata once; version, download and checksum all come from it
curl -fsSL -H "Accept: application/vnd.github+json" "$API_URL" -o "$TMP_DIR/release.json"

TAG=$(sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$TMP_DIR/release.json" | head -n 1)
LATEST_VER=${TAG#v}
EXPECTED_SHA=$(awk -v a="\"$ASSET\"" 'index($0, "\"name\"") { found = index($0, a) ? 1 : 0; next } found && index($0, "\"digest\"") { sub(/.*"sha256:/, ""); sub(/".*/, ""); print; exit }' "$TMP_DIR/release.json")

if [ -z "$TAG" ] || [ -z "$EXPECTED_SHA" ]; then
  echo "Error: Could not retrieve the latest version or checksum from GitHub." >&2
  exit 1
fi

# Get currently installed version (if present)
if [ -x "$BIN_PATH" ]; then
  CURRENT_VER=$("$BIN_PATH" --version-raw)
else
  CURRENT_VER="none"
fi

if [ "$CURRENT_VER" = "$LATEST_VER" ]; then
  fix_owner
  echo "fastfetch is already up to date ($CURRENT_VER). Skipping download."
  exit 0
else
  echo "Updating fastfetch: $CURRENT_VER -> $LATEST_VER"
fi

DOWNLOAD_URL="https://github.com/fastfetch-cli/fastfetch/releases/download/$TAG/$ASSET"
curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/fastfetch.tar.gz"
echo "$EXPECTED_SHA $TMP_DIR/fastfetch.tar.gz" | sha256sum -c -

tar --no-same-owner -xzf "$TMP_DIR/fastfetch.tar.gz" -C "$TMP_DIR"
SRC="$TMP_DIR/fastfetch-linux-$ARCH/usr"

mkdir -p /opt/bin /opt/share
for f in "$SRC"/bin/*; do
  name=${f##*/}
  install -o root -g root -m 755 "$f" "/opt/bin/.$name.new"
  mv -f "/opt/bin/.$name.new" "/opt/bin/$name"
done
cp -R "$SRC/share/." /opt/share/
fix_owner

echo "Successfully installed: $("$BIN_PATH" --version)"
