#!/usr/bin/env zx

// export-vscode-settings.ts - Export VS Code settings from local VS Code User directory into the repo
//
// Usage:
//   ./export-vscode-settings.ts
//
// Exports:
//   - mcp.json
//   - keybindings.json
//   - settings.json
//   - prompts/ (recursive)

// Ensure git is available
try {
  await $`command -v git`
} catch (error) {
  echo`Error: git not found. Install git.`
  process.exit(1)
}

// Ensure rsync is available
try {
  await $`command -v rsync`
} catch (error) {
  echo`Error: rsync not found. Install rsync.`
  process.exit(1)
}

// Centralized include patterns for rsync
const includes = [
  '/mcp.json',
  '/keybindings.json',
  '/settings.json',
  '/prompts/***'
]

const includeArgs = includes.flatMap(p => ['--include', p])

const scriptDir = __dirname
const repoRoot = (await $`git -C ${scriptDir} rev-parse --show-toplevel`).stdout.trim()

if (!repoRoot) {
  echo`Error: Could not determine destination path`
  process.exit(1)
}

const dest = `${repoRoot}/home/.vscode`
const src = `${process.env.HOME}/Library/Application Support/Code/User`

// Skip gracefully if source directory does not exist
try {
  await fs.access(src)
} catch (error) {
  echo`Error: Source VS Code User directory not found: ${src}.`
  process.exit(1)
}

await fs.mkdir(dest, { recursive: true })

await $`rsync -a --delete ${includeArgs} --exclude='*' ${src}/ ${dest}/`

echo`VS Code settings exported successfully.`
