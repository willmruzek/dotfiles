source ~/.git-completion.bash
source ./git-subrepo/.rc

# Theme

BASE16_SHELL=$HOME/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# Prompt

function _update_ps1() {
    PS1="$(powerline-shell $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# Aliases

alias sss='/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'
alias ls='LSCOLORS=gxfxcxdxbxexexabagacad /bin/ls -abFHGLOPW'
alias nuke='rm -rf'
alias dc='docker-compose'

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

export EDITOR=vim

######
## FZF
######

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

neofetch

