#!/bin/bash

set -e

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "⚠️  npm not available, skipping dependency installation"
    exit 0
fi

# Find the repository root by looking for package.json
# Start from the current directory and walk up
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT=""

while [ "$CURRENT_DIR" != "/" ]; do
    if [ -f "$CURRENT_DIR/package.json" ]; then
        REPO_ROOT="$CURRENT_DIR"
        break
    fi
    CURRENT_DIR="$(dirname "$CURRENT_DIR")"
done

# Check if we found the repository root
if [ -z "$REPO_ROOT" ]; then
    echo "⚠️  package.json not found in any parent directory, skipping dependency installation"
    exit 0
fi

echo "📦 Installing npm dependencies..."
cd "$REPO_ROOT"
npm install

echo "✅ npm dependencies installed"
