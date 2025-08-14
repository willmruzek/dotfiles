# github.com/willmruzek/dotfiles

My personal dotfiles managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## Quick Start

To set up these dotfiles on a new machine:

```bash
# Option 1: Direct install (recommended)
sh -c "$(curl -fsLS https://raw.githubusercontent.com/willmruzek/dotfiles/master/install.sh)"

# Option 2: Using chezmoi
chezmoi init --apply willmruzek
```

## What's Included

- **Git configuration** (`.gitconfig`)
- **Zsh configuration** (`.zshrc`, `.zprofile`)
- **Oh My Zsh custom settings** (themes, plugins, configs)
- **Homebrew packages** (`.Brewfile`)
- **chezmoi configuration**
- **VS Code settings sync scripts**

## Platform Support

**⚠️ macOS/Darwin Only**: These dotfiles are currently designed and tested for macOS systems only. The setup scripts assume Homebrew, macOS-specific paths, and Darwin-specific tools.

## Structure

- `home/` - Contains all dotfiles (chezmoi source directory)
- `home/.chezmoiscripts/` - Setup scripts (run_once_* scripts run only on first setup)
- `install.sh` - Bootstrap script for new machines

## Automatic Setup

The installation process will automatically:

1. Install chezmoi if not present
2. Install Homebrew if not present (macOS)
3. Install Oh My Zsh if not present
4. Install packages from Brewfile
5. Set zsh as default shell
6. Apply all dotfiles

## Manual Management

After initial setup, you can manage your dotfiles with:

```bash
# Edit a file
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Add a new file
chezmoi add ~/.newfile

# Update from repo
chezmoi update
```

## Features

### VS Code settings sync

Minimal helpers to move VS Code user settings between your Mac and this repo. Requires git and rsync.

- Export local → repo:

  ```bash
  ./home/.scripts/export-vscode-settings.sh
  ```

- Import repo → local (preview first by default):

  ```bash
  ./home/.scripts/import-vscode-settings.sh
  # flags: -n/--dry-run (preview only), -y/--yes (auto-approve)
  ```

Includes: mcp.json, keybindings.json, settings.json, prompts/ (recursive).

## TODO: Future Additions

### 🎯 High Priority - Core Development Tools

1. **SSH Configuration**
2. **GPG Configuration**

### 🛠️ Medium Priority - Development Workflow

1. **Group Related Configs**
   - `chezmoi add ~/.config/git/`               # Global git hooks and config
   - `chezmoi add ~/.config/zsh/completions/`   # Custom shell completions
   - Organize configs under `dot_config/` for better structure

2. **Vim Configuration**

## Alternative Dotfile Managers

See [dotfiles.github.io](https://dotfiles.github.io/) for more inspiration and examples.
