#!/usr/bin/env bash
read -p 'This script will erase/override many files. Do you want to run it (y/n)? ' -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Ask for sudo right away and get this script directory
sudo echo -n
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parent_dir="$(dirname "$current_dir")"

# We need xcode command tools on Mac
if [[  "$OSTYPE" == 'darwin'* ]]; then
    if ! xcode-select --print-path > /dev/null 2>&1; then
        echo Installing Xcode Command Line Tools...
        xcode-select --install &> /dev/null
        # Wait until XCode command tools are installed
        until xcode-select --print-path > /dev/null 2>&1; do
            sleep 5
        done
    fi
fi

echo Installing Brew packages...
. "$current_dir/brew.sh"
brew_dir=$(brew --prefix)

echo Installing Italics tmux terminfo...
tic "$parent_dir/tmux-xterm-256color-italic.terminfo"

echo Installing Nerd Fonts...
brew tap caskroom/fonts
brew cask install font-sourcecodepro-nerd-font
# Nerd fonts Source Code Pro version doesn't have italics so we install
# the official version
brew cask install font-source-code-pro

echo Installing Python3 modules...
pip3 install --user -r "$parent_dir"/python/requirements.txt
ipython3 kernel install

echo Setting up atom configuration...
. "$current_dir/atom.sh"

echo Installing zsh...
. "$current_dir/.sh"


echo Generating symlinks...
. "$current_dir/symlinks.sh"

echo Installing extra settings...
. "$current_dir/extras.sh"
