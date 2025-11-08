#!/usr/bin/env zx

// import-vscode-settings.ts - Import VS Code settings from repo into the local VS Code User directory
//
// Usage:
//   ./import-vscode-settings.ts [--dry-run|-n] [--yes|-y]
//
// Options:
//   -n, --dry-run  Preview diffs only; no backup or changes
//   -y, --yes      Auto-approve import (non-interactive)
//
// Imports:
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

// Parse flags
let autoYes = false
let dryRun = false

for (const arg of process.argv.slice(3)) {
  if (arg === '--yes' || arg === '-y') {
    autoYes = true
  } else if (arg === '--dry-run' || arg === '-n') {
    dryRun = true
  }
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

// Ensure repo root is determined
if (!repoRoot) {
  echo`Error: Could not determine source path`
  process.exit(1)
}

const src = `${repoRoot}/home/.vscode`
const dest = `${process.env.HOME}/Library/Application Support/Code/User`

// Ensure source directory exists
try {
  await fs.access(src)
} catch (error) {
  echo`Error: Source repo VS Code directory not found: ${src}.`
  process.exit(1)
}

// Ensure VS Code User directory exists
try {
  await fs.access(dest)
} catch (error) {
  echo`Error: Destination VS Code User directory not found: ${dest}.`
  process.exit(1)
}

// If dry-run, note it early
if (dryRun) {
  echo`Dry run: will preview changes only. No backup or import will be performed.`
}

// Backup existing settings into $dest/.dotfiles_backup/<timestamp>
if (!dryRun) {
  const backupRoot = `${dest}/.dotfiles_backup`
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19).replace('T', '-')
  const backupDir = `${backupRoot}/${timestamp}`
  await fs.mkdir(backupDir, { recursive: true })
  
  await $`rsync -a ${includeArgs} --exclude='/.dotfiles_backup/***' --exclude='*' ${dest}/ ${backupDir}/`
  echo`Backup created at: ${backupDir}`
}

// Preview planned changes using git-style color diff and require approval
let changes = 0
const jsonFiles = ['mcp', 'keybindings', 'settings']

echo`Planned changes:`
echo``

for (const f of jsonFiles) {
  const srcFile = `${src}/${f}.json`
  const destFile = `${dest}/${f}.json`
  
  try {
    await fs.access(srcFile)
    const hasFile = true
  } catch (e) {
    const hasFile = false
  }
  
  try {
    await fs.access(destFile)
    const hasFile = true
  } catch (e) {
    const hasFile = false
  }
  
  try {
    await $`git --no-pager diff --no-index --quiet -- ${destFile} ${srcFile}`
  } catch (error) {
    changes = 1
    try {
      await $`git --no-pager diff --no-index --color -- ${destFile} ${srcFile}`
    } catch (e) {
      // Diff returned non-zero, which is expected
    }
  }
}

try {
  await fs.access(`${src}/prompts`)
  const hasSrcPrompts = true
} catch (e) {
  const hasSrcPrompts = false
}

try {
  await fs.access(`${dest}/prompts`)
  const hasDestPrompts = true
} catch (e) {
  const hasDestPrompts = false
}

try {
  await $`git --no-pager diff --no-index --quiet -- ${dest}/prompts ${src}/prompts`
} catch (error) {
  changes = 1
  try {
    await $`git --no-pager diff --no-index --color -- ${dest}/prompts ${src}/prompts`
  } catch (e) {
    // Diff returned non-zero, which is expected
  }
}

if (changes === 0) {
  echo`No changes to import. Exiting.`
  process.exit(0)
}

// If dry-run, stop here after preview
if (dryRun) {
  echo`Dry run complete. Changes were not applied.`
  process.exit(0)
}

// Confirm import unless auto-approved
if (!autoYes) {
  const answer = await question("Proceed with import? [y/N]: ")
  if (!answer.match(/^[yY]([eE][sS])?$/)) {
    echo`Aborted.`
    process.exit(1)
  }
}

// Import from repo into local VS Code User directory
await $`rsync -a ${includeArgs} --exclude='*' ${src}/ ${dest}/`
