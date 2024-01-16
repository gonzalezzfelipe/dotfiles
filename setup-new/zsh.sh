# OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Zeta theme
mkdir -p ~/.oh-my-zsh/themes
curl \
  http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme \
  -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme
bash -c "$(curl -fsSL https://raw.githubusercontent.com/gonzalezzfelipe/zeta-zsh-theme/master/scripts/install.sh)"

# Required fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh
cd .. && rm -rf fonts
