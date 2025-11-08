#!/bin/bash

set -e

# Verify zx is available after npm install
# zx is installed as a dependency in package.json

if command -v npx &> /dev/null; then
    echo "✅ npx is available"
    
    # Check if zx is available via npx
    if npx zx --version &> /dev/null; then
        echo "✅ zx is available via npx"
    else
        echo "⚠️  zx not yet available via npx (will be installed by npm install)"
    fi
else
    echo "❌ npx not found. Node.js must be installed first."
    echo "    Please install Node.js before running this script."
    exit 1
fi
