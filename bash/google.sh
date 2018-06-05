###################
###   ANDROID   ###
###################
export PATH=$PATH:$HOME/gbin:/google/data/ro/projects/android

###################
###   Google3   ###
###################

X20="/google/data/rw/users/${USER:0:2}/$USER"

alias x20='cd $X20'

# G4 diff functions
function g4meld() {
  if [ -n "$DISPLAY" ] ; then export G4MULTIDIFF=1 ; fi
  P4DIFF='bash -c "meld \${@/#:/--diff}" padding-to-occupy-argv0' g4 diff $@
}

export P4DIFF='diff -u'
if command -v colordiff >& /dev/null; then
    export P4DIFF='colordiff -u'
fi
export P4MERGE='bash -c "chmod u+w \$1 ; meld \$2 \$1 \$3 ; cp \$1 \$4" padding-to-occupy-argv0'

#   Quit Eclipse safely from the command line
alias quit_eclipse='/google/src/head/depot/google3/devtools/ide/eclipse/scripts/quit-eclipse-gracefully.sh'
#   Launches a Cider window in the current client: go/cider-here
alias cider='/google/src/head/depot/google3/experimental/users/edupereda/scripts/cider/cider_here.sh --noapp'
#   Find Buganizer component: go/guess_component
alias buganizer_component='/google/data/ro/users/ad/adorokhine/guess_component.par'

# Define a no-op pcolor function if one doesn't exist, so the _prompt functions
# will work, just without coloring.
command -v pcolor >& /dev/null || pcolor() { :; }

