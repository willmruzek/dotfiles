source ~/.git-completion.bash

BASE16_SHELL=$HOME/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

function _update_ps1() {
    PS1="$(powerline-shell $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

set -o vi

alias sss='/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'
alias ls='LSCOLORS=gxfxcxdxbxexexabagacad /bin/ls -abFHGLOPW'
alias nuke='rm -rf'
alias dc='docker-compose'

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

export EDITOR=vim

neofetch
