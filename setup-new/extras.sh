#!/usr/bin/env bash
brew_dir=$(brew --prefix)

gem install teamocil

# Install fzf plugins
if type "fzf" > /dev/null 2>&1; then
    git clone https://github.com/urbainvaes/fzf-marks.git
    (
        cd fzf-marks || exit
        cp fzf-marks.plugin.bash  "$brew_dir/opt/fzf/shell"
    )
    rm -rf fzf-marks
fi

# Chromance colors
git clone \
  https://github.com/aaron-williamson/base16-alacritty.git \
  "$HOME/.aaron-williamson-alacritty-theme"
