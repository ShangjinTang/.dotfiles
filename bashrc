[ -f ~/.dotfiles/.shrc ] && source ~/.dotfiles/.shrc

# Use aliases from zsh
alias ls='ls --color=auto'
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias ll='ls -lAh'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias md='mkdir -p'
alias rd=rmdir
alias -='cd -'
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias _='sudo '

[ -f /usr/share/bash-completion/completions/git ] && source /usr/share/bash-completion/completions/git

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# set tmux auto launch by flag file
if [ -f ~/.dotfiles.local/.flag.tmux_auto_launch ]; then
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        tmux send-keys -t 0:1 " cd ~ && clear" Enter &> /dev/null
        tmux attach-session -t 0:1 2> /dev/null || tmux new-session -s 0
    fi
fi
