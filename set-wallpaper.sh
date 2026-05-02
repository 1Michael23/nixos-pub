#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="${NH_FLAKE:-$HOME/dev/nixos-pub}"
WALLPAPER_DIR="$SCRIPT_DIR/modules/home/desktop/wallpapers"
TARGET="$WALLPAPER_DIR/current.png"

if [ $# -eq 0 ]; then
  echo "Usage: $0 <path-to-wallpaper>"
  echo "Copies the wallpaper into the repo and rebuilds with 'nh os switch'."
  exit 1
fi

SOURCE="$1"

if [ ! -f "$SOURCE" ]; then
  echo "Error: file not found: $SOURCE"
  exit 1
fi

mkdir -p "$WALLPAPER_DIR"
cp "$SOURCE" "$TARGET"
echo "Wallpaper copied to $TARGET"

cd "$SCRIPT_DIR"
echo "Rebuilding NixOS configuration..."
nh os switch
