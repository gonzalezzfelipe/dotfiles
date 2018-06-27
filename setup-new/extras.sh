#!/usr/bin/env bash
brew_dir=$(brew --prefix)

# Install fzf plugins
if type "fzf" > /dev/null 2>&1; then
    git clone https://github.com/urbainvaes/fzf-marks.git
    (
        cd fzf-marks || exit
        cp fzf-marks.plugin.bash  "$brew_dir/opt/fzf/shell"
    )
    rm -rf fzf-marks
fi
