#!/bin/bash

set -e

# Install zx before other scripts run
# This ensures all .mjs scripts can execute with zx

if command -v npx &> /dev/null; then
    # npx is available, zx will be available via npx zx
    echo "✅ npx is available (zx will be available via npx)"
elif command -v brew &> /dev/null; then
    # Install zx via Homebrew
    if ! command -v zx &> /dev/null; then
        echo "📦 Installing zx via Homebrew..."
        brew install zx
    else
        echo "✅ zx is already installed"
    fi
else
    echo "⚠️  Neither npx nor brew available. zx scripts may not work."
    echo "    Please install Node.js (for npx) or Homebrew first."
fi
