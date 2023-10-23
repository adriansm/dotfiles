fish_add_path $HOME/.local/bin

status is-interactive || exit

# Commands to run in interactive sessions can go here
if type -q direnv
    direnv hook fish | source
end

set -x EDITOR nvim
