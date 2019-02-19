# OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# BulletTrain
mkdir -p $ZSH_CUSTOM/themes/
curl \
  http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme \
  -o $ZSH_CUSTOM/themes/bullet-train.zsh-theme

# Required fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh
cd .. && rm -rf fonts
