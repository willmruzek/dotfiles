#!/usr/bin/env zx

// Bootstrap script to install chezmoi and apply dotfiles

// Check if chezmoi is installed
let chezmoi
try {
  await $`command -v chezmoi`
  chezmoi = 'chezmoi'
} catch (error) {
  const binDir = `${process.env.HOME}/.local/bin`
  chezmoi = `${binDir}/chezmoi`
  
  try {
    await $`command -v curl`
    await $`sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b ${binDir}`
  } catch (curlError) {
    try {
      await $`command -v wget`
      await $`sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b ${binDir}`
    } catch (wgetError) {
      console.error("To install chezmoi, you must have curl or wget installed.")
      process.exit(1)
    }
  }
}

// Get script directory
const scriptDir = __dirname

console.log(scriptDir)

// Execute chezmoi init with apply
await $`${chezmoi} init --apply --source=${scriptDir}`
