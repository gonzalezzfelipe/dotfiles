#!/usr/bin/env bash
# Install brew if not installed
if ! type "brew" > /dev/null 2>&1; then
    brew_prefix='Home'
    brew_dir='/usr/local'
    if [[ ! "$OSTYPE" == 'darwin'* ]]; then
        brew_prefix='Linux'
        brew_dir="$HOME/.linuxbrew"
    fi
    echo "Installing brew..."
    ruby -e "$(curl -fsSl 'https://raw.githubusercontent.com/'$brew_prefix'brew/install/master/install')"
    export PATH="$brew_dir/bin:$brew_dir/sbin:$PATH"
else
    brew_dir=$(brew --prefix)
fi

# Use latest homebrew and update any already installed formulae
echo "Updating Brew..."
brew update && brew upgrade

# Use bundle
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
brew bundle --file $current_dir/Brewfile

# zsh
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells'
sudo chsh -s /usr/local/bin/zsh

# Remove outdated versions
brew cleanup
