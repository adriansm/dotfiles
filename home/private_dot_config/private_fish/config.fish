if status is-interactive
    # Commands to run in interactive sessions can go here
    if type -q direnv
        direnv hook fish | source
    end
end
