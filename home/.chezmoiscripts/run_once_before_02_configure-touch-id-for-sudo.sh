#!/bin/bash

set -e

# Configure Touch ID for sudo
if [ ! -f /etc/pam.d/sudo_local ]; then
    echo "🔐 Setting up Touch ID for sudo..."
    sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
    echo "auth sufficient pam_tid.so" | sudo tee -a /etc/pam.d/sudo_local
    echo "✅ Touch ID for sudo configured"
elif ! grep -q "pam_tid.so" /etc/pam.d/sudo_local; then
    echo "🔐 Adding Touch ID authentication to existing sudo_local..."
    echo "auth sufficient pam_tid.so" | sudo tee -a /etc/pam.d/sudo_local
    echo "✅ Touch ID for sudo configured"
else
    echo "✅ Touch ID for sudo already configured"
fi
