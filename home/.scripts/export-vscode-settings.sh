#!/bin/bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
repo_root="$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null)"

if [[ -z "${repo_root}" ]]; then
  echo "Error: could not determine destination path" >&2
  exit 1
fi

dest="$repo_root/home/.vscode"
src="$HOME/Library/Application Support/Code/User"

# Ensure rsync is available
if ! command -v rsync >/dev/null 2>&1; then
  echo "Error: rsync not found. Please install rsync." >&2
  exit 1
fi

# Skip gracefully if source directory does not exist
if [[ ! -d "$src" ]]; then
  echo "Source VS Code User directory not found: $src. Skipping export." >&2
  exit 0
fi

mkdir -p "$dest"

rsync -a --delete \
  --include='/mcp.json' \
  --include='/keybindings.json' \
  --include='/settings.json' \
  --include='/prompts/***' \
  --exclude='*' \
  "$src/" "$dest/"

echo "VS Code settings exported successfully."
