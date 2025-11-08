#!/bin/bash

set -e

# Install zx before other scripts run via npm
# This ensures all .mjs scripts can execute with zx

if command -v npx &> /dev/null; then
    # npx is available, zx will be available via npx zx
    echo "✅ npx is available (zx will be available via npx)"
else
    echo "⚠️  npx not available. Installing zx globally via npm..."
    if command -v npm &> /dev/null; then
        npm install -g zx
        echo "✅ zx installed via npm"
    else
        echo "❌ npm not found. Node.js must be installed first."
        echo "    Please install Node.js before running this script."
        exit 1
    fi
fi
