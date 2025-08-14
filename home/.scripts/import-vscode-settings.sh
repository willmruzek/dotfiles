#!/bin/bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
repo_root="$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null)"

if [[ -z "${repo_root}" ]]; then
  echo "Error: could not determine source path (git toplevel)" >&2
  exit 1
fi

src="$repo_root/home/.vscode"
dest="$HOME/Library/Application Support/Code/User"

# Ensure rsync is available
if ! command -v rsync >/dev/null 2>&1; then
  echo "Error: rsync not found. Please install rsync." >&2
  exit 1
fi

# Skip gracefully if source directory does not exist
if [[ ! -d "$src" ]]; then
  echo "Source repo VS Code directory not found: $src. Nothing to import." >&2
  exit 0
fi

mkdir -p "$dest"

# Backup existing settings into $dest/.dotfiles_backup/<timestamp>
backup_root="$dest/.dotfiles_backup"
backup_dir="$backup_root/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
rsync -a \
  --include='/mcp.json' \
  --include='/keybindings.json' \
  --include='/settings.json' \
  --include='/prompts/***' \
  --exclude='/.dotfiles_backup/***' \
  --exclude='*' \
  "$dest/" "$backup_dir/"

# Import from repo into local VS Code User directory
rsync -a \
  --include='/mcp.json' \
  --include='/keybindings.json' \
  --include='/settings.json' \
  --include='/prompts/***' \
  --exclude='*' \
  "$src/" "$dest/"


