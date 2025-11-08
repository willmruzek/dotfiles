#!/bin/sh

set -e # -e: exit on error

# Ensure Node.js/npm is available for npx zx
if ! command -v npx >/dev/null 2>&1; then
  echo "📦 Node.js not found. Installing via Homebrew..."
  
  # Install Homebrew first if not present
  if ! command -v brew >/dev/null 2>&1; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [ "$(uname -m)" = "arm64" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
  
  # Install Node.js
  brew install node
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

# Run the zx version of the install script using npx
exec npx zx "$script_dir/install.mjs"
