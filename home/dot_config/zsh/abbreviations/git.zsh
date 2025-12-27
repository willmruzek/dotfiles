# Git abbreviations migrated from oh-my-zsh git aliases
autoload -Uz is-at-least
Git_abbr_git_version="${${(As: :)$(git version 2>/dev/null)}[3]}"

# Jump to repository root
abbr grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# Run git
abbr g='git'

# Add files to index
abbr ga='git add %'

# Add all changes
abbr gaa='git add --all %'

# Mark work in progress commit
abbr gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'

# Blame with whitespace ignored
abbr gbl='git blame -w %'

# Create or inspect branches
abbr gb='git branch %'

# List all branches
abbr gba='git branch --all'

# Delete branch
abbr gbd='git branch --delete %'

# List remote branches
abbr gbr='git branch --remote'

# Set upstream to origin/current branch
abbr ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'

# Checkout branch or path
abbr gco='git checkout %'

# Checkout with submodules
abbr gcor='git checkout --recurse-submodules %'

# Create and checkout new branch
abbr gcb='git checkout -b %'

# Checkout develop branch helper
abbr gcd='git checkout $(git_develop_branch)'

# Checkout main branch helper
abbr gcm='git checkout $(git_main_branch)'

# Cherry-pick commit
abbr gcp='git cherry-pick %'

# Clone with submodules
abbr gcl='git clone --recurse-submodules %'

# Commit with message and all changes
abbr gcam='git commit --all --message "%"'

# Commit with message
abbr gcmsg='git commit --message "%"'

# Verbose commit
abbr gc='git commit --verbose'

# Verbose commit all
abbr gca='git commit --verbose --all'

# Amend verbose commit
abbr gc\!='git commit --verbose --amend'

# Diff working tree vs index
abbr gd='git diff %'

# Diff cached changes
abbr gdca='git diff --cached %'

# Diff staged changes
abbr gds='git diff --staged %'

# Fetch from remotes
abbr gf='git fetch'

# Fetch origin
abbr gfo='git fetch origin %'

# One-line decorated log
abbr glo='git log --oneline --decorate %'

# One-line graph log
abbr glog='git log --oneline --decorate --graph %'

# One-line graph log all
abbr gloga='git log --oneline --decorate --graph --all'

# Merge branch
abbr gm='git merge %'

# Abort merge
abbr gma='git merge --abort'

# Continue merge
abbr gmc='git merge --continue'

# Squash merge
abbr gms='git merge --squash %'

# Fast-forward only merge
abbr gmff='git merge --ff-only %'

# Merge origin main
abbr gmom='git merge origin/$(git_main_branch)'

# Merge upstream main
abbr gmum='git merge upstream/$(git_main_branch)'

# Pull changes
abbr gl='git pull %'

# Pull with rebase
abbr gpr='git pull --rebase %'

# Pull with rebase verbose
abbr gprv='git pull --rebase -v %'

# Pull origin main with rebase
abbr gprom='git pull --rebase origin $(git_main_branch)'

# Interactive rebase pull origin main
abbr gpromi='git pull --rebase=interactive origin $(git_main_branch)'

# Pull upstream main with rebase
abbr gprum='git pull --rebase upstream $(git_main_branch)'

# Interactive rebase pull upstream main
abbr gprumi='git pull --rebase=interactive upstream $(git_main_branch)'

# Pull current branch from origin
abbr ggpull='git pull origin "$(git_current_branch)"'

# Pull current branch from upstream
abbr gluc='git pull upstream $(git_current_branch)'

# Pull main from upstream
abbr glum='git pull upstream $(git_main_branch)'

# Push changes
abbr gp='git push %'

# Force push
abbr gpf\!='git push --force %'

# Push all and tags
abbr gpoat='git push origin --all && git push origin --tags'

# Delete remote branch
abbr gpod='git push origin --delete %'

# Push current branch
abbr ggpush='git push origin "$(git_current_branch)"'

# Push to upstream remote
abbr gpu='git push upstream %'

# Reset to given target
abbr grh='git reset %'

# Reset hard to target
abbr grhh='git reset --hard %'

# Reset soft to target
abbr grhs='git reset --soft %'

# Rebase onto target
abbr grb='git rebase %'

# Rebase abort
abbr grba='git rebase --abort'

# Rebase continue
abbr grbc='git rebase --continue'

# Interactive rebase
abbr grbi='git rebase --interactive %'

# Rebase skip
abbr grbs='git rebase --skip'

# Rebase onto develop helper
abbr grbd='git rebase $(git_develop_branch)'

# Rebase onto main helper
abbr grbm='git rebase $(git_main_branch)'

# Rebase onto origin main
abbr grbom='git rebase origin/$(git_main_branch)'

# Rebase onto upstream main
abbr grbum='git rebase upstream/$(git_main_branch)'

# Remote commands
abbr gr='git remote'

# Verbose remotes
abbr grv='git remote --verbose'

# Add remote
abbr gra='git remote add %'

# Remove remote
abbr grrm='git remote remove %'

# Rename remote
abbr grmv='git remote rename % %'

# Set remote URL
abbr grset='git remote set-url % %'

# Update remotes
abbr grup='git remote update'

# Revert commit
abbr grev='git revert %'

# Abort revert
abbr greva='git revert --abort'

# Continue revert
abbr grevc='git revert --continue'

# Remove file
abbr grm='git rm %'

# Remove file from index only
abbr grmc='git rm --cached %'

# Show commit
abbr gsh='git show %'

# Show commit with signature
abbr gsps='git show --pretty=short --show-signature %'

# Stash everything
abbr gstall='git stash --all'

# Apply stash to working tree
abbr gstaa='git stash apply %'

# Drop stash entry
abbr gstd='git stash drop %'

# List stashes
abbr gstl='git stash list'

# Pop top stash
abbr gstp='git stash pop %'

# Show status
abbr gst='git status'

# Short status
abbr gss='git status --short'

# Short status with branch
abbr gsb='git status --short --branch'

# Init submodules
abbr gsi='git submodule init'

# Update submodules
abbr gsu='git submodule update %'

# Switch branches
abbr gsw='git switch %'

# Create and switch branch
abbr gswc='git switch --create %'

# Switch to develop helper
abbr gswd='git switch $(git_develop_branch)'
# Switch to main helper
abbr gswm='git switch $(git_main_branch)'

# List tags sorted
abbr gtv='git tag | sort -V'

# Worktree commands
abbr gwt='git worktree'

# Add worktree
abbr gwta='git worktree add %'

# List worktrees
abbr gwtls='git worktree list'

# Move worktree
abbr gwtmv='git worktree move %'

# Remove worktree
abbr gwtrm='git worktree remove %'

# Stash include untracked
abbr gstu='gsta --include-untracked %'

unset Git_abbr_git_version
