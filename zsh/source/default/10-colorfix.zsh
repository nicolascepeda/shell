#!/bin/zsh

# Portable colors.
# SO: http://stackoverflow.com/questions/6159856/how-do-zsh-ansi-colour-codes-work
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$terminfo[none]$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"
PRMT_CLR=$PR_YELLOW
PRMT_CLR_LGHT=$PR_LIGHT_YELLOW

##>> Colordiff
# alias colordiff if it's on the path
hash colordiff 2>/dev/null >/dev/null && alias diff='colordiff'