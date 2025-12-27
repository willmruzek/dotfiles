#!/bin/bash

set -euo pipefail

# export-vscode-settings.sh - Export VS Code or Cursor settings from local User directory into the repo
#
# Usage:
#   ./export-vscode-settings.sh <vscode|cursor>
#
# Exports:
#   - mcp.json
#   - keybindings.json
#   - settings.json
#   - prompts/ (recursive)

# Ensure git is available
if ! command -v git >/dev/null 2>&1; then
  echo "Error: git not found. Install git." >&2
  exit 1
fi

# Ensure rsync is available
if ! command -v rsync >/dev/null 2>&1; then
  echo "Error: rsync not found. Install rsync." >&2
  exit 1
fi

# Parse arguments
TARGET_EDITOR=""
if [[ $# -gt 0 ]]; then
  TARGET_EDITOR="$1"
fi

if [[ "$TARGET_EDITOR" != "vscode" && "$TARGET_EDITOR" != "cursor" ]]; then
  echo "Error: You must specify the target editor." >&2
  echo "Usage: $0 <vscode|cursor>" >&2
  exit 1
fi

# Centralized include patterns for rsync
INCLUDES=(
  /mcp.json
  /keybindings.json
  /settings.json
  /prompts/***
)
INCLUDE_ARGS=()
for p in "${INCLUDES[@]}"; do
  INCLUDE_ARGS+=("--include=$p")
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
repo_root="$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null)"

if [[ -z "${repo_root}" ]]; then
  echo "Error: Could not determine destination path" >&2
  exit 1
fi

if [[ "$TARGET_EDITOR" == "vscode" ]]; then
  dest="$repo_root/home/.vscode"
  src="$HOME/Library/Application Support/Code/User"
elif [[ "$TARGET_EDITOR" == "cursor" ]]; then
  dest="$repo_root/home/.cursor"
  src="$HOME/Library/Application Support/Cursor/User"
fi

# Skip gracefully if source directory does not exist
if [[ ! -d "$src" ]]; then
  echo "Error: Source VS Code User directory not found: $src." >&2
  exit 1
fi

mkdir -p "$dest"

rsync -a --delete \
  "${INCLUDE_ARGS[@]}" \
  --exclude='*' \
  "$src/" "$dest/"

echo "VS Code settings exported successfully."
