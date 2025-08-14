#!/bin/bash

set -e

# Re-run this script when the Brewfile changes
# Brewfile hash: {{ include "dot_Brewfile.tmpl" | sha256sum }}

# Install packages from Brewfile if it exists (only if Homebrew is available)
if command -v brew &> /dev/null && [ -f "$HOME/.Brewfile" ]; then
    echo "📋 Installing packages from Brewfile..."
    export HOMEBREW_BUNDLE_FILE="$HOME/.Brewfile"
    brew bundle install
elif ! command -v brew &> /dev/null; then
    echo "⚠️  Homebrew not available, skipping package installation"
else
    echo "⚠️  No Brewfile found, skipping package installation"
fi

echo "✨ Setup complete!"
