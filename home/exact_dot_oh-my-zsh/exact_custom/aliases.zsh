alias gco="git checkout \$(git branch -vv --sort=-committerdate | fzf --header 'git checkout' | awk '{print \$1}' | sed 's#remotes/origin/##' | xargs)"
alias gcor="git checkout \$(git branch -r -vv --sort=-committerdate | fzf --header 'git checkout' | awk '{print \$1}' | sed 's#remotes/origin/##' | xargs)"
