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

# Latest zsh
brew install zsh zsh-completions
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells'
sudo chsh -s /usr/local/bin/zsh

# Git
brew install git

# Compiler related
brew install gcc
brew install llvm
brew install libomp
brew install openblas
brew install coreutils  # (realpath, etc)

brew install python3

# Tmux latest versions
brew install --HEAD tmux

# Install Atom
brew tap caskroom/cask
brew cask install atom

# Databases
brew install postgresql
brew install mysql
brew install protobuf  # Required by python's mysql-connector
brew install redis

# Other useful binaries
brew install the_silver_searcher
brew install fzf
brew install z
brew install htop
if [[  "$OSTYPE" == 'darwin'* ]]; then
    brew install reattach-to-user-namespace
    brew install rmtrash
fi
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew install unrar
brew install shellcheck
brew install imgcat
brew install rsync
brew install bat
brew install fd
brew install tree

# Remove outdated versions
brew cleanup
