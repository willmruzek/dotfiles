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
