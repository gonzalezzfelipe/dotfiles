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
    ln -s "$dotfiles_dir/zshrc" "$HOME/.zshrc"
    echo Created .zshrc symlink
fi
. "$HOME/.zshrc"

if type "vim" > /dev/null 2>&1; then
    rm -rf "$HOME/.vimrc"
    ln -s "$dotfiles_dir/vimrc" "$HOME/.vimrc"
    echo Created .vimrc symlink
fi

if type "nvim" > /dev/null 2>&1; then
    rm -rf "$HOME/.config/nvim"
    ln -s "$dotfiles_dir/config/nvim" "$HOME/.config/nvim"
    echo Created .config/nvim folder symlink
fi

if type "starship" > /dev/null 2>&1; then
    rm -rf "$HOME/.config/starship.toml"
    mkdir "$HOME/.config"
    ln -s "$dotfiles_dir/config/starship.toml" "$HOME/.config/starship.toml"
    echo Created .config/starship.toml symlink
fi

if type "ctags" > /dev/null 2>&1; then
    rm -rf "$HOME/.ctags"
    ln -s "$dotfiles_dir/ctags" "$HOME/.ctags"
    echo Created .ctags symlink
fi

if type "k9s" > /dev/null 2>&1; then
    rm -rf "$HOME/.config/k9s"
    ln -s "$dotfiles_dir/config/k9s" "$HOME/.config/k9s"
    ln -s "$dotfiles_dir/config/k9s/skins" "$HOME/.config/k9s/skins"
    echo Created .config/k9s folder symlink
fi

if type "tmux" > /dev/null 2>&1; then
    rm -rf "$HOME/.tmux"
    ln -s "$dotfiles_dir/tmux" "$HOME/.tmux"
    ln -s "$dotfiles_dir/tmux/teamocil" "$HOME/.teamocil"
    echo Created .tmux folder symlink
fi

if type "zellij" > /dev/null 2>&1; then
    rm -rf "$HOME/.config/zellij"
    ln -s "$dotfiles_dir/config/zellij" "$HOME/.config/zellij"
    echo Created .config/zellij folder symlink
fi

if type "ghostty" > /dev/null 2>&1; then
    rm -rf "$HOME/.config/ghostty"
    ln -s "$dotfiles_dir/config/ghostty" "$HOME/.config/ghostty"
    echo Created .config/ghostty folder symlink
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
    editor = vim
    excludesfile = ~/.gitignore
[web]
    browser = start
[credential]
    helper = osxkeychain
EOF
echo Created .gitconfig file
