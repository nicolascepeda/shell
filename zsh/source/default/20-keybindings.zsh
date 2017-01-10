#!/bin/zsh
#
## Use emacs like keys for cl
## http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
bindkey -v
#
## Make jj instead of esc go into normal-mode
bindkey -M viins 'jj' vi-cmd-mode
#
bindkey "^r" history-incremental-search-backward
bindkey "^n" history-incremental-search-forward
#
autoload -Uz select-word-style
select-word-style normal
#
bindkey '^[w'     vi-backward-kill-word
bindkey '^[f'     vi-forward-word
bindkey '^[b'     vi-backward-word
