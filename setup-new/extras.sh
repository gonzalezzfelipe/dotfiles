#!/usr/bin/env bash
brew_dir=$(brew --prefix)

# Chromance colors
git clone \
  https://github.com/aaron-williamson/base16-alacritty.git \
  "$HOME/.aaron-williamson-alacritty-theme"

# Nvim Chad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
