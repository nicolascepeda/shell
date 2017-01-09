#!/bin/zsh

###>> SSH
# Handling of ssh identities is easier in OSx. ssh-agent has
# a keyring binding and will load all keys automatically when
# added with the -K option.

# Only add keys not yet loaded
if [[ -d $HOME/.ssh/keys_auto ]]; then
    for k in $(ls $HOME/.ssh/keys_auto)
    do
        _i=`ssh-add -l | grep "$k"`
        _loaded=$?

        if [ "$_loaded" -eq 1 ]; then
            ssh-add -k "$HOME/.ssh/keys_auto/$k"
        fi
    done
fi

###>> Colorized 'ls'
export LSCOLORS='cxfxcxdxbxegedabagacad'

PRMT_CLR=$PR_YELLOW

#alias vagrant='ruby -r /Users/me/data/ext/vagrant/bundle/bundler/setup.rb /Users/me/data/ext/vagrant/bin/vagrant'

###>> Aliases
alias readlink='greadlink'
alias ls='ls -G'

alias o='open '
alias tmp='cd $HOME/Downloads'