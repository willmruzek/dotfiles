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

## Platform Support

**⚠️ macOS/Darwin Only**: These dotfiles are currently designed and tested for macOS systems only. The setup scripts assume Homebrew, macOS-specific paths, and Darwin-specific tools.

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

## 1Password Integration

Personal secrets are stored in [1Password](https://1password.com) and you'll
need the [1Password CLI](https://developer.1password.com/docs/cli/) installed.
Login to 1Password with:

```console
eval $(op signin)
```

## Structure

- `home/` - Contains all dotfiles (chezmoi source directory)
- `home/.chezmoiscripts/` - Setup scripts (run_once_* scripts run only on first setup)
- `install.sh` - Bootstrap script for new machines

## TODO: Future Additions

### 🎯 High Priority - Core Development Tools

1. **SSH Configuration**
2. **GPG Configuration**

### 🛠️ Medium Priority - Development Workflow

3. **Group Related Configs**
   - `chezmoi add ~/.config/git/`               # Global git hooks and config
   - `chezmoi add ~/.config/zsh/completions/`   # Custom shell completions
   - Organize configs under `dot_config/` for better structure

4. **Vim Configuration**

## Alternative Dotfile Managers

See [dotfiles.github.io](https://dotfiles.github.io/) for more inspiration and examples.
