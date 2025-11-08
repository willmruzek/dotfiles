#!/bin/bash

set -e

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Homebrew not found."
    read -p "Would you like to install Homebrew? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        echo "✅ Homebrew installed"
    else
        echo "⏭️  Skipping Homebrew installation"
        exit 0
    fi
else
    echo "✅ Homebrew is already installed"
fi
