#!/bin/zsh

#--------------------
# For sane cd
alias ..='cd ..'
alias ...='.. && cd ..'
alias ....='... && cd ..'
alias h='cd ~/'
alias dl='cd ~/Downloads'

alias l='ls -lh'
alias ll='ls -lha'
alias grep='grep --color'
alias f='grep -r'
alias diff='grc diff'
alias mk='mkdir -p'
alias mc='MC_SKIN="$HOME/.config/mc/nicedark.ini" EDITOR="vim" mc'
alias p='print -l'
alias pp='p $path'
alias ps="ps aux | grep "
alias sudo='sudo '
# Assume ~/.ssh/config has a Host definition
# setting credentials & co
alias ssht='ssh -f -N '
alias sk='keybase'
alias s='gpg'
#alias secs'keybase pgp'
alias y='pbcopy <'

#--------------------
# Emacs
alias e='emacs -nw'
alias ec='emacsclient -a emacs --no-wait --socket emacs-server '

#--------------------
# Git
# See http://nuclearsquid.com/writings/git-tricks-tips-workflows/

alias g='git'
#alias gl='g log --graph --decorate --all --oneline'
alias gl='g l'
alias gll='g ll'
alias gs='g status'
alias ga='g add '
alias gc='gitcommitwrapper'
alias gp='g push'
alias gpo='g push origin'
alias gu='g fetch'
alias gur='g pull --rebase'
alias gb='g branch'
alias gt='g tag'
alias gch='g checkout'
alias gchb='g checkout -B'
alias gm='g merge'
alias gsa='g submodule add'

#--------------------
# Docker related aliases
alias d='docker'
alias db='docker build'
alias di='docker images'
alias dps='d ps'
alias dk='d kill'
alias drm='d rm'

#--------------------
# Vagrant
alias v='vagrant'
alias vx='vagrant-exec'

#--------------------
# TMUX
alias t='tmux '
alias ts='t new -s '
alias tl='t list-sessions'
alias ta='t attach -t '
alias td='t detach'
alias tm='t move-window'
alias tms='tm -t'

#--------------------
# nmap
alias psctcp='nmap -Pn'
alias pscudp='nmap -sU'

#-------------------
alias p='cd ~/code'