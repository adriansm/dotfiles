#!/usr/bin/env fish

if not functions --query fisher
    echo "Installing fisher and fisher plugins"
    curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher
    fish -c "fisher update"
end
