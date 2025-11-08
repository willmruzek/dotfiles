#!/usr/bin/env zx

// Install Homebrew if not present
try {
  await $`command -v brew`
  console.log("✅ Homebrew is already installed")
} catch (error) {
  console.log("📦 Homebrew not found.")
  
  const response = await question("Would you like to install Homebrew? (y/N): ")
  
  if (response.match(/^[Yy]$/)) {
    console.log("📦 Installing Homebrew...")
    await $`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
    
    // Add Homebrew to PATH for Apple Silicon Macs
    const arch = (await $`uname -m`).stdout.trim()
    if (arch === "arm64") {
      await $`echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile`
      await $`eval "$(/opt/homebrew/bin/brew shellenv)"`
    }
  } else {
    console.log("⏭️  Skipping Homebrew installation")
  }
}
