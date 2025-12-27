#!/bin/bash

set -euo pipefail

# import-vscode-settings.sh - Import VS Code or Cursor settings from repo into the local User directory
#
# Usage:
#   ./import-vscode-settings.sh <vscode|cursor> [--dry-run|-n] [--yes|-y]
#
# Options:
#   -n, --dry-run  Preview diffs only; no backup or changes
#   -y, --yes      Auto-approve import (non-interactive)
#
# Imports:
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

# Flags
AUTO_YES=0
DRY_RUN=0
TARGET_EDITOR=""

for arg in "$@"; do
  case "$arg" in
    --yes|-y) AUTO_YES=1 ;;
    --dry-run|-n) DRY_RUN=1 ;;
    vscode|cursor) TARGET_EDITOR="$arg" ;;
  esac
done

if [[ -z "$TARGET_EDITOR" ]]; then
  echo "Error: You must specify the target editor." >&2
  echo "Usage: $0 <vscode|cursor> [--dry-run|-n] [--yes|-y]" >&2
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

# Ensure repo root is determined
if [[ -z "${repo_root}" ]]; then
  echo "Error: Could not determine source path" >&2
  exit 1
fi

if [[ "$TARGET_EDITOR" == "vscode" ]]; then
  src="$repo_root/home/.vscode"
  dest="$HOME/Library/Application Support/Code/User"
elif [[ "$TARGET_EDITOR" == "cursor" ]]; then
  src="$repo_root/home/.cursor"
  dest="$HOME/Library/Application Support/Cursor/User"
fi

# Ensure source directory exists
if [[ ! -d "$src" ]]; then
  echo "Error: Source repo $TARGET_EDITOR directory not found: $src." >&2
  exit 1
fi

# Ensure User directory exists
if [[ ! -d "$dest" ]]; then
  echo "Error: Destination $TARGET_EDITOR User directory not found: $dest." >&2
  exit 1
fi

# If dry-run, note it early
if [[ $DRY_RUN -eq 1 ]]; then
  echo "Dry run: will preview changes only. No backup or import will be performed." >&2
fi

# Backup existing settings into $dest/.dotfiles_backup/<timestamp>
if [[ $DRY_RUN -eq 0 ]]; then
  backup_root="$dest/.dotfiles_backup"
  backup_dir="$backup_root/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup_dir"
  rsync -a \
    "${INCLUDE_ARGS[@]}" \
    --exclude='/.dotfiles_backup/***' \
    --exclude='*' \
    "$dest/" "$backup_dir/"
  echo "Backup created at: $backup_dir" >&2
fi

# Preview planned changes using git-style color diff and require approval
changes=0
json_files=(mcp keybindings settings)

echo "Planned changes:" >&2
echo "" >&2
for f in "${json_files[@]}"; do
  src_f="$src/$f.json"
  dest_f="$dest/$f.json"
  if [[ -f "$src_f" || -f "$dest_f" ]]; then
    if ! git --no-pager diff --no-index --quiet -- "$dest_f" "$src_f"; then
      changes=1
      git --no-pager diff --no-index --color -- "$dest_f" "$src_f" || true
    fi
  fi
done

if [[ -d "$src/prompts" || -d "$dest/prompts" ]]; then
  if ! git --no-pager diff --no-index --quiet -- "$dest/prompts" "$src/prompts"; then
    changes=1
    git --no-pager diff --no-index --color -- "$dest/prompts" "$src/prompts" || true
  fi
fi

if [[ $changes -eq 0 ]]; then
  echo "No changes to import. Exiting." >&2
  exit 0
fi

# If dry-run, stop here after preview
if [[ $DRY_RUN -eq 1 ]]; then
  echo "Dry run complete. Changes were not applied." >&2
  exit 0
fi

# Confirm import unless auto-approved
if [[ $AUTO_YES -eq 0 ]]; then
  read -r -p "Proceed with import? [y/N]: " _ans </dev/tty
  case "${_ans}" in
    [yY]|[yY][eE][sS]) ;;
    *) echo "Aborted." >&2; exit 1;;
  esac
fi

# Import from repo into local VS Code User directory
rsync -a \
  "${INCLUDE_ARGS[@]}" \
  --exclude='*' \
  "$src/" "$dest/"
