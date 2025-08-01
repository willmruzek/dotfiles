#!/usr/bin/env zsh

##################################################
#              encourage-asdf-tools              #
##################################################

#================
# Helper Functions
#================

# --- Color output functions ---
encourage-asdf-tools-color-green() {
    echo "\033[32m$1\033[0m"
}

encourage-asdf-tools-color-yellow() {
    echo "\033[33m$1\033[0m"
}

encourage-asdf-tools-color-blue() {
    echo "\033[34m$1\033[0m"
}

encourage-asdf-tools-color-bold() {
    echo "\033[1m$1\033[0m"
}

# --- asdf setup steps ---

encourage-asdf-tools-print-tool-setup() {
    local tool="$1"
    echo "     - Install asdf: $(encourage-asdf-tools-color-green "brew install asdf")" >&2
    echo "     - Add to ~/.zshrc: $(encourage-asdf-tools-color-green "export PATH=\"\${ASDF_DATA_DIR:-\$HOME/.asdf}/shims:\$PATH\"")" >&2
    echo "     - Restart your terminal" >&2
    echo "     - For custom data directory & completions, see docs below" >&2
    encourage-asdf-tools-print-tool-plugin-install "$tool"
}

encourage-asdf-tools-print-tool-plugin-install() {
    local tool="$1"
    echo "     - Install the $tool plugin: $(encourage-asdf-tools-color-green "asdf plugin add $tool")" >&2
}

encourage-asdf-tools-print-tool-version-install() {
    local tool="$1"
    echo "     - Install a $tool version: $(encourage-asdf-tools-color-green "asdf install $tool <version>")" >&2
}

encourage-asdf-tools-print-tool-version-set() {
    local tool="$1"
    echo "     - Set the version:" >&2
    echo "       - Globally: $(encourage-asdf-tools-color-green "asdf global $tool <version>")" >&2
    echo "       - Locally: $(encourage-asdf-tools-color-green "asdf local $tool <version>")" >&2
}

encourage-asdf-tools-print-tool-list-versions() {
    local tool="$1"
    echo "     - List available versions: $(encourage-asdf-tools-color-green "asdf list all $tool")" >&2
}

# --- Tool context and messaging ---
encourage-asdf-tools-print-tool-context() {
    local tool_path="$1"
    local reason="$2"
    echo "   $(encourage-asdf-tools-color-yellow "Current path:") ${tool_path:-"not found"}" >&2
    echo "" >&2
    echo "   $(encourage-asdf-tools-color-yellow "Reason:") $reason" >&2
}

# --- Documentation links ---

encourage-asdf-tools-print-docs-getting-started() {
    echo "   📖 Docs: $(encourage-asdf-tools-color-blue "https://asdf-vm.com/guide/getting-started.html")" >&2
}

encourage-asdf-tools-print-docs-plugins() {
    echo "   📖 Docs: $(encourage-asdf-tools-color-blue "https://asdf-vm.com/manage/plugins.html")" >&2
}

encourage-asdf-tools-print-docs-versions() {
    echo "   📖 Docs: $(encourage-asdf-tools-color-blue "https://asdf-vm.com/manage/versions.html")" >&2
}

# --- Command output formatting ---

# Helper function to print command output separator
encourage-asdf-tools-print-command-output-header() {
    echo "" >&2
    echo "$(encourage-asdf-tools-color-yellow "───────── Command output ─────────")" >&2
    echo "" >&2
}

# Helper function to print the main error message
encourage-asdf-tools-print-tool-warning() {
    local tool="$1"
    echo "❌ $(encourage-asdf-tools-color-bold "$tool") is not managed by asdf" >&2
}

#==================
# Message Templates
#==================

# Case 1: Tool isn't installed yet
encourage-asdf-tools-message-case-1() {
    local tool="$1"

    echo "" >&2
    echo "❌ $(encourage-asdf-tools-color-bold "$tool") is not installed" >&2
    echo "" >&2
    echo "   $(encourage-asdf-tools-color-yellow "Next steps:")" >&2
    encourage-asdf-tools-print-tool-setup "$tool"
    encourage-asdf-tools-print-tool-list-versions "$tool"
    encourage-asdf-tools-print-tool-version-install "$tool"
    encourage-asdf-tools-print-tool-version-set "$tool"
    echo "" >&2
    encourage-asdf-tools-print-docs-getting-started
}

# Case 2a: Tool installed, but asdf isn't installed
encourage-asdf-tools-message-case-2a() {
    local tool="$1"
    local tool_path="$2"

    echo "" >&2
    encourage-asdf-tools-print-tool-warning "$tool"
    echo "" >&2
    encourage-asdf-tools-print-tool-context "$tool_path" "asdf is not installed"
    echo "" >&2
    echo "   $(encourage-asdf-tools-color-yellow "Next steps:")" >&2
    encourage-asdf-tools-print-tool-setup "$tool"
    encourage-asdf-tools-print-tool-list-versions "$tool"
    encourage-asdf-tools-print-tool-version-install "$tool"
    encourage-asdf-tools-print-tool-version-set "$tool"
    echo "" >&2
    encourage-asdf-tools-print-docs-getting-started
}

# Case 2b: Tool and asdf installed, but plugin isn't installed
encourage-asdf-tools-message-case-2b() {
    local tool="$1"
    local tool_path="$2"

    echo "" >&2
    encourage-asdf-tools-print-tool-warning "$tool"
    echo "" >&2
    encourage-asdf-tools-print-tool-context "${tool_path:-"not found"}" "No asdf plugin installed for $(encourage-asdf-tools-color-bold "$tool")"
    echo "" >&2
    echo "   $(encourage-asdf-tools-color-yellow "Next steps:")" >&2
    encourage-asdf-tools-print-tool-plugin-install "$tool"
    encourage-asdf-tools-print-tool-list-versions "$tool"
    encourage-asdf-tools-print-tool-version-install "$tool"
    encourage-asdf-tools-print-tool-version-set "$tool"
    echo "" >&2
    encourage-asdf-tools-print-docs-plugins
}

# Case 2c: Tool, asdf, and plugin installed, but no versions installed
encourage-asdf-tools-message-case-2c() {
    local tool="$1"
    local tool_path="$2"

    echo "" >&2
    encourage-asdf-tools-print-tool-warning "$tool"
    echo "" >&2
    encourage-asdf-tools-print-tool-context "${tool_path:-"not found"}" "$(encourage-asdf-tools-color-bold "$tool") plugin installed but no asdf versions installed"
    echo "" >&2
    echo "   $(encourage-asdf-tools-color-yellow "Next steps:")" >&2
    encourage-asdf-tools-print-tool-list-versions "$tool"
    encourage-asdf-tools-print-tool-version-install "$tool"
    encourage-asdf-tools-print-tool-version-set "$tool"
    echo "" >&2
    encourage-asdf-tools-print-docs-versions
}

# Case 2d: Everything installed, but no version set
encourage-asdf-tools-message-case-2d() {
    local tool="$1"
    local tool_path="$2"
    local installed_versions="$3"

    echo "" >&2
    encourage-asdf-tools-print-tool-warning "$tool"
    echo "" >&2
    encourage-asdf-tools-print-tool-context "${tool_path:-"not found"}" "$(encourage-asdf-tools-color-bold "$tool") plugin and versions installed but no asdf version is set (currently using system version)"
    echo "" >&2
    echo "   $(encourage-asdf-tools-color-yellow "Next steps:")" >&2
    encourage-asdf-tools-print-tool-version-set "$tool"
    echo "" >&2
    echo "   Available installed versions:" >&2
    echo "$installed_versions" | sed 's/^/     /' >&2
    echo "" >&2
    encourage-asdf-tools-print-docs-versions
}

#==================
# Testing Functions
#==================

# Test helper to simulate each case and show the exact error messages
encourage-asdf-tools-test-case() {
    local case_num="$1"
    local tool="${2:-python}"

    case "$case_num" in
        "1")
            echo "=== Testing Case 1: Tool isn't installed yet ==="
            encourage-asdf-tools-message-case-1 "$tool"
            ;;
        "2a")
            echo "=== Testing Case 2a: Tool installed, but asdf isn't installed ==="
            encourage-asdf-tools-message-case-2a "$tool" "/usr/bin/$tool"
            ;;
        "2b")
            echo "=== Testing Case 2b: Tool and asdf installed, but plugin isn't installed ==="
            encourage-asdf-tools-message-case-2b "$tool" "/usr/bin/$tool"
            ;;
        "2c")
            echo "=== Testing Case 2c: Tool, asdf, and plugin installed, but no versions installed ==="
            encourage-asdf-tools-message-case-2c "$tool" "/usr/bin/$tool"
            ;;
        "2d")
            echo "=== Testing Case 2d: Everything installed but no version set ==="
            local example_versions="  3.9.0"$'
'"  3.10.2"$'
'"  3.11.1 (current)"
            encourage-asdf-tools-message-case-2d "$tool" "/usr/bin/$tool" "$example_versions"
            ;;
        *)
            echo "Invalid test case: $case_num"
            echo "Available cases: 1, 2a, 2b, 2c, 2d"
            return 1
            ;;
    esac
}

# Quick test all cases for a tool
encourage-asdf-tools-test-all() {
    local tool="${1:-python}"
    echo "Testing all cases for tool: $tool"
    echo ""

    for case in "1" "2a" "2b" "2c" "2d"; do
        encourage-asdf-tools-test-case "$case" "$tool"
        echo ""
        echo "----------------------------------------"
        echo ""
    done
}

#===========
# Core Logic
#===========

# Check if tool is managed by asdf and properly configured
encourage-asdf-tools-validate-tool() {
    local tool="$1"
    local tool_path=$(whence -p "$tool" 2>/dev/null)

    # Case 1:
    #   - Tool isn't installed yet
    if [[ -z "$tool_path" ]]; then
        encourage-asdf-tools-message-case-1 "$tool"
        echo "" >&2
        return 1
    fi

    # Case 2a:
    #   - non-asdf tool exists
    #   - but asdf isn't installed
    if ! command -v asdf >/dev/null 2>&1; then
        encourage-asdf-tools-message-case-2a "$tool" "$tool_path"
        encourage-asdf-tools-print-command-output-header
        return 1
    fi

    # Case 2b:
    #   - Tool is installed
    #   - asdf is installed
    #   - but tool plugin isn't installed
    if ! asdf plugin list 2>/dev/null | grep -q "^$tool$"; then
        encourage-asdf-tools-message-case-2b "$tool" "$tool_path"
        encourage-asdf-tools-print-command-output-header
        return 1
    fi

    # Check if any versions are installed for this tool
    local installed_versions=$(asdf list "$tool" 2>/dev/null)

    # Case 2c:
    #   - Tool is installed
    #   - asdf is installed
    #   - plugin is installed
    #   - but no tool versions are installed
    if [[ -z "$installed_versions" || "$installed_versions" == *"No versions installed"* ]]; then
        encourage-asdf-tools-message-case-2c "$tool" "$tool_path"
        encourage-asdf-tools-print-command-output-header
        return 1
    fi

    # Check current version setting
    local current_output=$(asdf current "$tool" 2>/dev/null)
    local current=$(echo "$current_output" | awk '{print $2}')

    # Case 2d:
    #   - Tool is installed
    #   - asdf is installed
    #   - plugin is installed
    #   - versions are installed
    #   - but no version is set globally or locally
    if [[ "$current" == "system" || -z "$current" || "$current" == "No version set"* ]]; then
        encourage-asdf-tools-message-case-2d "$tool" "$tool_path" "$installed_versions"
        encourage-asdf-tools-print-command-output-header
        return 1
    fi

    return 0
}

#===================
# Tool Configuration
#===================

# Tools that come with macOS by default (most important to manage)
# These are language runtimes that benefit from per-project version management
typeset -ga encourage_asdf_tools_macos_default_tools=(
    python python3             # Python 2.7 and older Python 3.x
    ruby                       # Usually Ruby 2.x
    perl                       # System Perl
    php                        # System PHP
    java javac                 # System Java and compiler
)

# Additional tools that are commonly installed via Homebrew or other means
# These are development tools that benefit from per-project version management
typeset -ga encourage_asdf_tools_additional_tools=(
    node npm npx yarn pnpm     # Node.js ecosystem - different projects need different Node versions
    go gofmt                   # Go language tools - Go versions matter for compatibility
    rust cargo                 # Rust ecosystem - Rust has frequent breaking changes
    terraform                  # Infrastructure as code - Terraform state compatibility
    poetry pipenv              # Python dependency management - tied to Python versions
    bundle gem                 # Ruby tools - tied to Ruby versions
    gradle maven               # Java build tools - tied to Java versions
)

# Allow users to override or extend the tool list via environment variables
# ASDF_ENCOURAGE_TOOLS - completely override the tool list
# ASDF_ENCOURAGE_ADDITIONAL_TOOLS - add to the default list
# ASDF_ENCOURAGE_DISABLE_COMMAND_NOT_FOUND - disable the command_not_found_handler (default: false)
typeset -ga encourage_asdf_tools_default_tools=(${encourage_asdf_tools_macos_default_tools[@]} ${encourage_asdf_tools_additional_tools[@]})
typeset -ga encourage_asdf_tools_user_additional=(${ASDF_ENCOURAGE_ADDITIONAL_TOOLS[@]})
typeset -ga encourage_asdf_tools_guarded_tools=(${ASDF_ENCOURAGE_TOOLS[@]:-${encourage_asdf_tools_default_tools[@]} ${encourage_asdf_tools_user_additional[@]}})

#===========
# Hook Setup
#===========

# Preexec hook approach (preserves autocompletion, shows warnings)
# This validates commands before execution and shows informational warnings
encourage-asdf-tools-preexec() {
    local cmd_array=(${(z)1})
    local cmd=${cmd_array[1]}

    # Skip if command is empty
    [[ -z "$cmd" ]] && return 0

    # Skip if the command contains path separators (it's likely a path, not a command)
    [[ "$cmd" == */* ]] && return 0

    # Check if this command is in our guarded tools list AND the command exists
    if (( ${encourage_asdf_tools_guarded_tools[(Ie)$cmd]} )) && command -v "$cmd" >/dev/null 2>&1; then
        # Show warning but don't prevent execution (only for existing commands)
        encourage-asdf-tools-validate-tool "$cmd" || true
    fi
}

# Add our hook to the preexec_functions array (avoid duplicates)
[[ " ${preexec_functions[*]} " =~ " encourage-asdf-tools-preexec " ]] || preexec_functions+=(encourage-asdf-tools-preexec)

# Handle command not found for our guarded tools (unless disabled)
if [[ "${ASDF_ENCOURAGE_DISABLE_COMMAND_NOT_FOUND:-false}" != "true" ]]; then
    command_not_found_handler() {
        local cmd="$1"

        # Check if this command is in our guarded tools list
        if (( ${encourage_asdf_tools_guarded_tools[(Ie)$cmd]} )); then
            # Show our educational message instead of generic "command not found"
            encourage-asdf-tools-validate-tool "$cmd" || true
            return 0  # Return 0 to indicate we handled the error ourselves
        fi

        # For non-guarded tools, print standard message and return 127
        print "zsh: command not found: $cmd" >&2
        return 127
    }
fi
