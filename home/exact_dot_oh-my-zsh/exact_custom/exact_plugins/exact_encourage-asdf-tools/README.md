# Encourage asdf Tools Plugin

A zsh plugin that provides helpful educational guidance for managing development tools with [asdf](https://asdf-vm.com/) instead of using potentially outdated system or Homebrew versions. This plugin focuses on **language runtimes and development tools that benefit from per-project version management**, promoting consistent, reproducible development environments across projects and team members through informative messages and setup guidance.

## Who is this for?

For those who are:

- **Setting up a new machine** and want helpful guidance to avoid version headaches from day one
- **Migrating to asdf** from Homebrew/system tools and want educational assistance during the switch
- **Working on multiple projects** that need different tool versions (Node 16 for legacy, Node 20 for new projects)

**Note**: This plugin provides educational guidance for tools that typically need different versions per project (language runtimes, build tools, etc.). Global utilities like `git`, `curl`, or `vim` are better managed through Homebrew or other system package managers.

## Installation

### Plain zsh

1. Clone the plugin to your preferred location:
   ```bash
   git clone https://github.com/yourusername/encourage-asdf-tools.git ~/.zsh/plugins/encourage-asdf-tools
   ```

2. Source the plugin in your `.zshrc`:
   ```bash
   source ~/.zsh/plugins/encourage-asdf-tools/encourage-asdf-tools.plugin.zsh
   ```

3. Restart your terminal or reload your shell configuration.

### Oh My Zsh

1. Clone this plugin to your Oh My Zsh custom plugins directory:
   ```bash
   git clone https://github.com/yourusername/encourage-asdf-tools.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/encourage-asdf-tools
   ```

2. Add the plugin to your `.zshrc`:
   ```bash
   plugins=(... encourage-asdf-tools)
   ```

3. Restart your terminal or reload your shell configuration.

## How It Works

The plugin provides educational guidance when you use specified development tools and:

1. **Shows setup guidance if the tool is missing** - provides step-by-step instructions for setting up asdf and the tool
2. **Provides asdf installation help if needed** - guides through asdf installation if not present
3. **Assists with plugin setup** - walks through plugin installation if the tool plugin isn't installed
4. **Helps configure versions** - provides guidance on setting up global or local versions
5. **Allows normal execution** - lets you use tools normally while providing helpful context

## Tool Lists

### macOS Default Tools (Always Protected)
These tools come with macOS and are often outdated:
- `python` - macOS ships with Python 2.7
- `python3` - Usually an older Python 3.x version
- `ruby` - Often Ruby 2.x instead of current 3.x
- `perl` - System Perl version
- `php` - System PHP version
- `java` - System Java version
- `javac` - System Java compiler

### Additional Tools (Configurable)
Common tools often installed via Homebrew:

**Node.js Ecosystem:**
- `node` - Node.js runtime
- `npm` - Node package manager
- `npx` - Node package runner
- `yarn` - Alternative Node package manager
- `pnpm` - Fast, disk space efficient package manager

**Systems Programming:**
- `go` - Go programming language
- `gofmt` - Go code formatter
- `rust` - Rust programming language
- `cargo` - Rust package manager

**Infrastructure & DevOps:**
- `terraform` - Infrastructure as code
- `kubectl` - Kubernetes command-line tool
- `helm` - Kubernetes package manager
- `docker-compose` - Container orchestration tool

**Language-Specific Tools:**
- `poetry` - Modern Python dependency management
- `pipenv` - Python dependency management
- `bundle` - Ruby dependency manager
- `gem` - Ruby package manager
- `gradle` - Java/Kotlin build tool
- `maven` - Java project management tool

## Configuration

### Environment Variable Configuration

Add these to your `.zshenv` or `.zshrc` file.

#### Add tools to the default list:
```bash
export ASDF_ENCOURAGE_ADDITIONAL_TOOLS=(go rust terraform docker-compose)
```

#### Completely override the tool list:
```bash
export ASDF_ENCOURAGE_TOOLS=(python node ruby)
```

#### Disable command not found handler:
```bash
export ASDF_ENCOURAGE_DISABLE_COMMAND_NOT_FOUND=true
```

**`command_not_found_handler` limitation:**
zsh only allows one `command_not_found_handler` function at a time. If you have other plugins or system utilities that define this handler (like command-not-found packages), they may conflict. When disabled, the plugin will still provide educational guidance for existing tools via preexec hooks, but won't show messages for completely missing tools.

**When to disable:**
- You have other plugins that provide command-not-found functionality
- You want to preserve system command-not-found utilities
- You prefer minimal integration (guidance only for existing tools)

## Example Guidance Messages

When a tool is not managed by asdf:

```
❌ python is not managed by asdf

   Current path: /usr/bin/python

   Reason: asdf is not installed

   Next steps:
     - Install asdf: brew install asdf
     - Add to ~/.zshrc: export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
     - Restart your terminal
     - For custom data directory & completions, see docs below
     - Install the python plugin: asdf plugin add python
     - List available versions: asdf list all python
     - Install a python version: asdf install python <version>
     - Set the version:
       - Globally: asdf global python <version>
       - Locally: asdf local python <version>

   📖 Docs: https://asdf-vm.com/guide/getting-started.html
```

## Troubleshooting

### Disable for a single command
If you need to use a system tool temporarily:
```bash
command python script.py  # Bypasses the plugin
```

### Check current tool configuration
```bash
asdf current          # Shows all configured tools
asdf current python   # Shows Python version info
```

### List available versions
```bash
asdf list all python  # Shows all installable Python versions
asdf list python      # Shows installed Python versions
