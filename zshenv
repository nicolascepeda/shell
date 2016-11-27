#!/bin/zsh
# read also from scripts, not just from interactive shells
# adds the stuff in front of the $PATH (I'm tired of trying
# to protect $PATH ordering).

SYSTEM_DEPENDENT="$HOME/.zsh/$(uname).zshenv"
HOST_DEPENDENT="$HOME/.zsh/$(hostname -s).zshenv"

if [[ -a $SYSTEM_DEPENDENT ]]; then
source $SYSTEM_DEPENDENT
fi

if [[ -a $HOST_DEPENDENT ]]; then
source $HOST_DEPENDENT
fi
