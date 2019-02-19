#!/usr/bin/env bash
# Check bash major version
bash_version=${BASH_VERSION:0:1}

# Ask for dotfiles dir. Note: the -i flag is only available on Bash 4
cur_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# The actual dotfiles dir is the directory above the current one
cur_dir="$(dirname "$cur_dir")"
if [[ $bash_version -gt 3 ]]; then
    read -r -e -p "Enter dotfiles directory: " -i "$cur_dir" dotfiles_dir
else
    read -r -e -p "Enter dotfiles directory: " dotfiles_dir
fi
while [ ! -d "$dotfiles_dir" ]; do
    (>&2 echo "$dotfiles_dir: No such directory")
    if [[ $bash_version -gt 3 ]]; then
        read -r -e -p "Enter dotfiles directory: " -i "$HOME/" dotfiles_dir
    else
        read -r -e -p "Enter dotfiles directory: " dotfiles_dir
    fi
done

# Strip last (potential) slash
dotfiles_dir=${dotfiles_dir%/}

echo Creating symlinks under "$HOME"/

# First symlink bashrc and reload it without logging out and back in
if type "zsh" > /dev/null 2>&1; then
    rm -rf "$HOME/.zshrc"
    ln -s "$dotfiles_dir/zshrc" "$HOME/.zsh"
    echo Created .zshrc symlink
fi
. "$HOME/.zshrc"

if type "ctags" > /dev/null 2>&1; then
    rm -rf "$HOME/.ctags"
    ln -s "$dotfiles_dir/ctags" "$HOME/.ctags"
    echo Created .ctags symlink
fi
if type "tmux" > /dev/null 2>&1; then
    rm -rf "$HOME/.tmux"
    ln -s "$dotfiles_dir/tmux" "$HOME/.tmux"
    echo Created .tmux folder symlink
fi
if type "pip" > /dev/null 2>&1; then
    rm -rf "$HOME/.config/pip"
    ln -s "$dotfiles_dir/config/pip" "$HOME/.config/pip"
    echo Created .config/pip folder symlink
fi
rm -rf "$HOME/.gitignore"
ln -s "$dotfiles_dir/gitignore" "$HOME/.gitignore"
echo Created .gitignore symlink

cat > "$HOME/.gitconfig" << EOF
[user]
    name = gonzalezzfelipe
    email = gonzalezz_felipe@hotmail.com
[push]
    default = simple
[core]
    editor = nvim
    excludesfile = ~/.gitignore
[web]
    browser = start
[credential]
    helper = osxkeychain
EOF
echo Created .gitconfig file
