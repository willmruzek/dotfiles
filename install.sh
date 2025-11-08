#!/bin/sh

set -e # -e: exit on error

# Ensure Node.js/npm is available for zx scripts that chezmoi will run
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
  
  # Install Node.js LTS
  brew install node
fi

# Install chezmoi if not present
if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

# exec: replace current process with chezmoi init
exec "$chezmoi" init --apply "--source=$script_dir"
