#!/bin/zsh
# read also from scripts, not just from interactive shells
# adds the stuff in front of the $PATH (I'm tired of trying
# to protect $PATH ordering).

# This makes cd'ing to frequently used dirs a swift!
# Credits: http://robots.thoughtbot.com/cding-to-frequently-used-directories-in-zsh
cdpath=($HOME $HOME/data/Documents $HOME/data/projects)

# Java
# Once Apple removes Java Preferences pane the command below will
# no longer work. This currently evaluates to Java 7. JVMs are
# located in '/Library/Java/JavaVirtualMachines/*' by default.

# Make sure no main window is being shown when invoking 'lein repl'
export LEIN_JVM_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Djava.awt.headless=true -Xmx1g"

export GRAILS_HOME=/opt/grails-2.3.5
export PATH="$GRAILS_HOME/bin:$PATH"


#JAVA_HOME='/Library/Java/JavaVirtualMachines/java/Contents/Home'
#export PATH="$JAVA_HOME/bin:$PATH"

#ANDROID_HOME="/Applications/adt/sdk"
#export PATH="$ANDROID_HOME/platform-tools:$PATH"
#export PATH="$ANDROID_HOME/tools:$PATH"

# Include custom bin location in path
export PATH="$HOME/.bin:$PATH"

# JavaScript console
# I've created a subdir $JSC_HOME/bin and symlinked jsc to there as I don't
# want to expose the contents of $JSC_HOME.
# Checkout http://www.phpied.com/javascript-shell-scripting/ for further ado
JSC_HOME="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources"
export PATH="$JSC_HOME/bin:$PATH"

EMACS_HOME="/Applications/Emacs.app/Contents/MacOS"
export PATH="$EMACS_HOME/bin:$PATH"

# Mac Ports
MAC_PORTS='/opt/local/bin:/opt/local/sbin'
export PATH="$MAC_PORTS:$PATH"

# Haskell
#export CABAL_HOME="$HOME/.cabal"
#export HASKELL_HOME="$HOME/Library/Haskell"
#export PATH="$CABAL_HOME/bin:$HASKELL_HOME/bin:$PATH"

# ImageMagick
#export MAGICK_HOME="/Applications/ImageMagick"
#export PATH="$MAGICK_HOME/bin:$PATH"
#export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"

# Ruby
#export GEM_HOME="$HOME/.gem/ruby/1.9.1"
#export PATH="$GEM_HOME/bin:$PATH"
export DOC_ROOT="$HOME/Documents"
