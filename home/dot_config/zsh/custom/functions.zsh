git_worktree_clone() {
    # Must provide repo URL
    if [ $# -lt 1 ]; then
        echo "fatal: You must specify a repository to clone."
        echo
        echo "usage: git wtclone <repo> [<dir>]"

        exit 1
    fi

    # Set up variables
    url="${1}"
    urldir="$(basename "${url}")"
    gitdir="${urldir%.*}"

    # If a second argument is provided, use it as the directory name
    if [ $# -ge 2 ]; then
        gitdir=${2}
    fi

    # Helpers to clean up
    cleanup_tmpdir() {
        popd 2>/dev/null || true
    }
    trap cleanup_tmpdir SIGINT

    cleanup_and_exit() {
        cleanup_tmpdir
        if test "$1" = 0 -o -z "$1" ; then
            return 0
        else
            return "${1}"
        fi
    }

    # Create git directory
    mkdir "${gitdir}" || cleanup_and_exit 1
    pushd "${gitdir}" || cleanup_and_exit 1

    # Clone git repo
    git clone --bare "${url}" .bare || cleanup_and_exit 1
    echo "gitdir: ./.bare" > .git

    # Remove all local branches that bare clone created
    # We'll create only the main branch later
    git for-each-ref --format='%(refname:short)' refs/heads | xargs git branch -D &>/dev/null || true

    # Manually set remote origin fetch, --bare doesn't do this
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch || cleanup_and_exit 1

    # Enable logallrefupdates, --bare doesn't do this
    # When true: Git maintains a reflog (reference log) for all refs,
    # tracking every change to branches, HEAD, etc.
    git config --add core.logallrefupdates true

    # Checkout main branch
    main_branch=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

    git branch -f "${main_branch}" "origin/${main_branch}" || cleanup_and_exit 1
    git worktree add "${main_branch}" || cleanup_and_exit 1

    cleanup_and_exit 0
}

alias gwtc="git_worktree_clone"

# List all available commands (executables, aliases, functions)
list_commands() {
    local show_help=false
    local show_executables=true
    local show_aliases=true
    local show_functions=true
    local filter=""

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help=true
                shift
                ;;
            -e|--executables-only)
                show_aliases=false
                show_functions=false
                shift
                ;;
            -a|--aliases-only)
                show_executables=false
                show_functions=false
                shift
                ;;
            -f|--functions-only)
                show_executables=false
                show_aliases=false
                shift
                ;;
            -g|--grep)
                filter="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                show_help=true
                break
                ;;
        esac
    done

    if $show_help; then
        echo "Usage: list_commands [OPTIONS]"
        echo ""
        echo "Lists all available commands including executables, aliases, and functions."
        echo ""
        echo "OPTIONS:"
        echo "  -h, --help              Show this help message"
        echo "  -e, --executables-only  Show only executables from PATH"
        echo "  -a, --aliases-only      Show only zsh aliases"
        echo "  -f, --functions-only    Show only zsh functions"
        echo "  -g, --grep PATTERN      Filter results by pattern"
        echo ""
        echo "Examples:"
        echo "  list_commands                    # Show all commands"
        echo "  list_commands -e                # Show only executables"
        echo "  list_commands -g git             # Show commands containing 'git'"
        echo "  list_commands -f -g backup       # Show functions containing 'backup'"
        return 0
    fi

    local temp_file=$(mktemp)

    # Collect executables from PATH
    if $show_executables; then
        # Use compgen to get all executables, add [exec] label
        compgen -c | sort -u | sed 's/^/[exec]   /' >> "$temp_file"
    fi

    # Collect aliases
    if $show_aliases; then
        # Get all aliases, add [alias] label
        alias | sed 's/^alias //' | sed 's/^/[alias]  /' | sort >> "$temp_file"
    fi

    # Collect functions
    if $show_functions; then
        # Get all function names, add [func] label
        print -l ${(ok)functions} | sed 's/^/[func]   /' | sort >> "$temp_file"
    fi

    # Sort all commands together by name (ignoring the label)
    sort -k2 "$temp_file" -o "$temp_file"

    # Apply filter if specified and display results
    if [[ -n "$filter" ]]; then
        grep -i "$filter" "$temp_file" | less
    else
        less "$temp_file"
    fi

    # Clean up
    rm "$temp_file"
}

alias lsc="list_commands"

# Kill process listening on a specific port
kill-port () {
    local pids=$(lsof -i tcp:$1 2>/dev/null | grep LISTEN | awk '{print $2}')
    [ -z "$pids" ] && echo "No process on port $1" && return
    echo "$pids" | xargs kill -9
}

alias kp="kill-port"

# Find the location of a completion function
compfile() {
  if [[ -z "$1" ]]; then
    echo "Usage: compfile <command>"
    return 1
  fi

  local comp_name="_$1"
  local found=0

  for dir in $fpath; do
    if [[ -f "$dir/$comp_name" ]]; then
      echo "$dir/$comp_name"
      found=1
    fi
  done

  if [[ $found -eq 0 ]]; then
    echo "No completion file found for:  $1"
    return 1
  fi
}
