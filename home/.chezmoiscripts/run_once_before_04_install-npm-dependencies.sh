#!/bin/bash

set -e

# Get the repository root (where package.json lives)
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "⚠️  npm not available, skipping dependency installation"
    exit 0
fi

# Check if package.json exists
if [ ! -f "$REPO_ROOT/package.json" ]; then
    echo "⚠️  package.json not found, skipping dependency installation"
    exit 0
fi

echo "📦 Installing npm dependencies..."
cd "$REPO_ROOT"
npm install

echo "✅ npm dependencies installed"
