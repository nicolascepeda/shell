#!/bin/zsh

#export PATH="$HOME/.bin:$PATH"
source $HOME/.zsh/zshenv

export EDITOR=vim

# Use emacs like keys for cl
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
bindkey -e

# Make jj instead of esc go into normal-mode
#bindkey -M viins 'jj' vi-cmd-mode

bindkey "^r" history-incremental-search-backward
# Moving around
#bindkey "^d" forward-char
#bindkey "^H" backward-char
#bindkey "^N" forward-word
#bindkey "^T" backward-word

# Killing
#bindkey "^D" kill-char
#bindkey "^X" kill-char
#bindkey "^X" backward-kill-char
#bindkey "^L" kill-word
#bindkey "^P" backward-kill-word
#bindkey "^K" kill-whole-line

# change $fpath before calling compinit
autoload -Uz compinit
#autoload -Uz complist
autoload -Uz zutil
compinit

##>> Shell customization
# shell history
# taken from: http://en.gentoo-wiki.com/wiki/Zsh
fpath=($HOME/.zsh/functions $fpath)

autoload -U vagrant-exec

autoload -U promptinit
promptinit

zstyle ':completion:*' completer _expand _complete _ignored _approximate

#autoload -U zmv
autoload -Uz zutil
autoload -Uz compinit
compinit

export HISTSIZE=1000
export SAVEHIST=1000 # only saved after logout
export HISTFILE=$HOME/.zshhist
setopt \
    inc_append_history \
    hist_save_no_dups \
    hist_reduce_blanks \
    hist_ignore_all_dups

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


# Auto cd -> cdpath, see Darwin.zshenv or other platform specific
# configuration
setopt \
    autocd \
    extendedglob \
    notify \
    extendedhistory
    #completealiases
    #nomatch

###>> Aliases
alias sudo='sudo '
alias ll='ls -lha'
alias l='ls -lh'
alias p='print -l'
alias pp='p $path'

alias e='$EDITOR'

alias v='vagrant'
alias vx='vagrant-exec'

# Git related aliases
# See http://nuclearsquid.com/writings/git-tricks-tips-workflows/
alias g='git'
alias gs='g status'
alias ga='g add'
alias gc='g commit -a -m'
alias gp='g push'
alias gpo='g push origin'
alias gu='g pull'
alias gb='g branch'
alias gt='g tag'
alias gch='g checkout'
alias gm='g merge'
#complete -o default -o nospace -F _git g

##>> Colordiff
# alias colordiff if it's on the path
hash colordiff 2>/dev/null >/dev/null && alias diff='colordiff'

##>> System and host agnostic overrides & extensions
SYSTEM_DEPENDENT="$HOME/.zsh/$(uname).zshrc"
HOST_DEPENDENT="$HOME/.zsh/$(hostname -s).zshrc"

LC_ALL=en_US.utf8
LANG=en_UK.utf8

if [[ -a $SYSTEM_DEPENDENT ]]; then
    source $SYSTEM_DEPENDENT
fi

if [[ -a $HOST_DEPENDENT ]]; then
    source $HOST_DEPENDENT
fi

##>> Prompt
# credits:
# - http://aperiodic.net/phil/prompt/
#     very thorough explanation of most of the things happening in
#     precmd, preexec, and setprompt. Thanks for putting that page
#     online.
# - Merci gäu dän


if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
    st=$($git status 2>/dev/null | tail -n 1)
    # Dirty hack to circumvent a change that broke the dirty flag in
    # a recent git version (I don't know exactly which one).
    st2=$($git status 2>/dev/null | tail -n 2)
    if [[ ( $st == "" ) && ( $st2 == "" ) ]]
    then
        echo ""
    else
        if [[ "$st" =~ ^nothing ]]
        then
            echo "%{$reset_color%} on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
        else
            echo "%{$reset_color%} on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
        fi
    fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

# Compute the length of git status information shown in prompt
git_prompt_size () {
 local zero='%([BSUbfksu]|([FB]|){*})' # removes escape characters
 promptgit="$(git_dirty)"
 ${#${(S%%)promptgit//$~zero/}}
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

git_need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo ""
  else
    echo " %{$fg_bold[red]%}!%{$reset_color%}"
  fi
}


# calculate cmd extends
function precmd {
 local TERMWIDTH
 (( TERMWIDTH = ${COLUMNS} - 1 ))

 # truncate the path if it's too long.
 PR_FILLBAR=""
 PR_PWDLEN=""

 # compute size of prompt and pwd

 local promptsize=${#${(%):-%n@%m }}
 local pwdsize=${#${(%):-%~}}

 local zero='%([BSUbfksu]|([FB]|){*})' # removes escape characters
 local promptgit="$(git_dirty)$(git_need_push)"
 local promptgitsize=${#${(S%%)promptgit//$~zero/}}

  if [[ "$promptsize + $pwdsize + $promptgitsize" -gt $TERMWIDTH ]]; then
     ((PR_PWDLEN=$TERMWIDTH - $promptsize))
 else
     PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize + $promptgitsize)))..${PR_HBAR}.)}"
 fi

 # print a 'bell' character:
 # In combination with 'URxvt.urgentOnBell: true' in your ~/.Xresources,
 # this will set an X11 urgent flag on the window when the prompt gets
 # redrawn. Handy to get informed about longrunning commands
 # finishishing in the foreground in not currently visible windows.
 print -n '\a'
}

# preexec is executed just after pressing enter.
# it's used to set the window title to just the command used
# preexec () {
#   local CMD=${1[(wr)^(*=*|sudo|-*)]}
#   echo -ne "\ek$CMD\e\\"
# }

# called once to initialize things.
setprompt () {
 # need this so the prompt will work.
 setopt prompt_subst



  # see if we can use extended characters to look nicer.
 typeset -A altchar
 set -A altchar ${(s..)terminfo[acsc]}
 PR_SET_CHARSET="%{$terminfo[enacs]%}"
 PR_SHIFT_IN="%{$terminfo[smacs]%}"
 PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
 PR_HBAR=${altchar[q]:--}
 PR_ULCORNER=${altchar[l]:--}
 PR_LLCORNER=${altchar[m]:--}
 PR_LRCORNER=${altchar[j]:--}
 PR_URCORNER=${altchar[k]:--}

 # left prompt
 PROMPT='$PR_SET_CHARSET\
%(!.%SROOT%s.%n)$PRMT_CLR@%m\
$PR_NO_COLOUR %$PR_PWDLEN<...<$PRMT_CLR_LGHT${(%):-%~}$(git_dirty)$(git_need_push)\
%<<$PR_NO_COLOUR $PR_SHIFT_IN${(e)PR_FILLBAR}$PR_SHIFT_OUT
$PR_NO_COLOUR%! %(!.$PR_RED.$PR_WHITE)%#$PR_NO_COLOUR '
 #PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[yellow]%}%m %{$fg[green]%}%~ %{$reset_color%}%% "

 # right prompt
 RPROMPT=''

 # continuation prompt
 PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

# Remove duplicates
typeset -U path

setprompt

# colorized stderr
# http://en.gentoo-wiki.com/wiki/Zsh
# TODO: there seme to be an error in coloring...
#exec 2>>(while read line; do
#  print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)
