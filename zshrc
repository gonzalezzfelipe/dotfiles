export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="zeta"

HIST_STAMPS="yyyy-mm-dd"
plugins=(git autojump tmux osx colorize yarn)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# Options {{{

# Brew directory
if type "brew" > /dev/null 2>&1; then
    brew_dir=$(brew --prefix)
else
    if [[ "$OSTYPE" == 'darwin'* ]]; then
        if [ -d '/usr/local/bin' ]; then
            brew_dir='/usr/local'
        fi
    else
        if [ -d "$HOME/.linuxbrew" ]; then
            brew_dir="$HOME/.linuxbrew"
        else
            brew_dir='/mnt/.linuxbrew'
        fi
    fi
fi

if [[ "$OSTYPE" == 'darwin'* ]]; then
    # Path settings
    PATH="/usr/bin:/bin:/usr/sbin:/sbin"
    export PATH="$brew_dir/bin:$brew_dir/sbin:$PATH" # homebrew
    if [ -d "/Library/TeX/texbin" ]; then
        export PATH="/Library/TeX/texbin:$PATH" # basictex
    fi
    if [ -d "/Applications/MATLAB_R2015b.app/bin" ]; then
        export PATH="/Applications/MATLAB_R2015b.app/bin/matlab:$PATH" # matlab
    fi
    export PKG_CONFIG_PATH="$brew_dir/lib/pkgconfig:$brew_dir/lib"

    # Symlink cask apps to Applications folder
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # Set english utf-8 locale
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    # Enable terminal colors and highlight directories in blue, symbolic links
    # in purple and executable files in red (the actual colors depend on iTerm's
    # colorscheme)
    # Note: in Iterm we use ether the afterglow colorscheme or
    # https://github.com/anunez/one-dark-iterm
    export CLICOLOR=1
    export LSCOLORS=exfxCxDxbxegedabagaced
else
    export PATH="$brew_dir/bin:$brew_dir/sbin:$PATH"
    export MANPATH="$brew_dir/share/man:$MANPATH"
    export INFOPATH="$brew_dir/share/info:$INFOPATH"

    # Highlight directories in blue, symbolic links in purple and executable
    # files in red
    export LS_COLORS="di=0;34:ln=0;35:ex=0;31:"
fi

# Path OS agnostic settings
if type "go" > /dev/null 2>&1; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
fi

export EDITOR=vim

# }}}
# Alias {{{

# Bash
alias sh='bash'
alias u='cd ..'
alias 2u='cd ../..'
alias 3u='cd ../../..'
alias 4u='cd ../../../..'
alias h='cd ~'
alias ll='ls -lah'
alias q='exit'
alias c='clear'
alias o='open'
alias sudo='sudo ' # Expand aliases when using sudo
alias ssh='TERM=xterm-256color; ssh'
alias ds='du -shc * | sort -rh'
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias pcli='ssh fgonzalez@prd-amber-pivot.jampp.com -t '\
'tmux new -A -s fgonzalez-presto '\
'"presto-cli\ --server\ emr-prd-data.jampp.com:8889\ --catalog\ hive\ '\
'--schema\ aleph\ --user\ fgonzalez"'
alias hcli="ssh fgonzalez@prd-amber-pivot.jampp.com -t "\
"tmux new -A -s fgonzalez-hive "\
"'beeline\ -u\ \"jdbc:hive2://emr-prd-etl.jampp.com:10000/default\;auth=noSasl\"\ -n\ hadoop'"

# Git
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gc='git commit --m'
alias gp='git push'
alias gpull='git pull'
alias gl='git log'
alias gb='git branch'
alias gch='git checkout'

# Postgres
alias pg_start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg_stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"

# Other binaries
if type "htop" > /dev/null 2>&1; then
    alias ht='htop'
fi
if type "bat" > /dev/null 2>&1; then
    # Colorized cat
    alias dog='bat --style numbers --theme TwoDark'
fi

if [[ "$OSTYPE" == 'darwin'* ]]; then
    # Differentiate and use colors for directories, symbolic links, etc.
    cd() { builtin cd "$@" && ls -GF; }

    # SSH and Tmux: connect to emr via ssh and then start tmux creating a new
    # session called fgonzalez or attaching to an existing one with that name.
    # Presto client
else
    # Differentiate and use colors for directories, symbolic links, etc.
    alias ls='ls -F --color=auto'
    # Change directory and list files
    cd() { builtin cd "$@" && ls -F --color=auto; }
fi

use () {
  while test $# -gt 0; do
    case "$1" in
      -h|--help)
        echo "This is an executable to generate a virtualenv of a name of "
        echo "choice, that is to be made on a folder that contains all other "
        echo "venvs."
        echo ""
        echo "Usage:"
        echo ">>> use NAME [OPTIONS]"
        echo ""
        echo ">>> use virtualenv  # Generates a virtualenv called virtualenv"
        echo ""
        echo ">>> use new_venv -p python3.6  # other venv, with specific version"
        echo ""
        echo ">>> use new_venv --reset  # Erase and recreate"
        echo " "
        echo "Args:"
        echo "NAME                      Name of the venv"
        echo " "
        echo "Options:"
        echo "-h, --help                Show brief help."
        echo "-p, --python PYTHON       Python executable to use to set up venv."
        echo "-i, --install             Install dependencies."
        echo "-r, --requirements FILE   Specify requirements file to install."
        echo "--reset                   Erases current venv and sets up a new one"
        kill -INT $$
        ;;
      --reset)
        local RESET=1
        shift
        ;;
      -p|--python)
        local PYTHON="--python=$2"
        shift
        shift
        ;;
      -r|--requirements)
        local REQUIREMENTS=$2
        shift
        shift
        ;;
      -d|--delete)
        local DELETE=1
        shift
        ;;
      -i|--install)
        local INSTALL=1
        shift
        ;;
      *)
        local NAME=$1
        shift
        ;;
    esac
  done
  local RESET=${RESET:-0}
  local DELETE=${DELETE:-0}
  local INSTALL=${INSTALL:-0}
  local REQUIREMENTS=${REQUIREMENTS:-requirements.txt}

  if [[ $NAME = "." ]]; then
    NAME="${PWD##*/}"  # If . then use local dir name
  fi

  local _PATH=$HOME/.venvs/$NAME
  if [ $DELETE = 1 ]; then
    echo "Deleting virtualenv..."
    echo $_PATH
    rm -rf "$_PATH"
    return
  fi
  if [ $RESET = 1 ]; then
    echo "Reseting virtualenv..."
    rm -rf "$_PATH"
  fi
  if [ ! -d "$_PATH" ]; then
    virtualenv $_PATH $PYTHON
  fi
  source $_PATH/bin/activate
  if [ $INSTALL = 1 ]; then
    if [ -f "$REQUIREMENTS" ]; then
      pip install -r $REQUIREMENTS
    else
      echo "Requirements file not found."
    fi
  fi
  echo "Done."
}

docker_start() {
  open --background -a Docker
}

color_list() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}

export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.6/bin
export PATH=$PATH:$HOME/Library/Python/3.6/bin

copy_git_token() {
  echo $GIT_TOKEN | pbcopy
}


add_ssh_host() {
  while test $# -gt 0; do
    case "$1" in
      --help)
        echo "Add a host to ~/.ssh/config."
        echo ""
        echo "Options:"
        echo "--help                    Show this help."
        echo "-h, --host HOST           Name to define host."
        echo "-u, --user USER           User to connect to host."
        echo "-i, --ip IPADRESS         IP Adress of host."
        echo "--interactive             Enable prompt to define this values."
        echo ""
        echo "Usage:"
        echo "$ add_ssh_host -h NAME -u USER -i IP"
        echo " "
        kill -INT $$
        ;;
      -h|--host)
        local _HOST=$2
        shift
        shift
        ;;
      -u|--user)
        local _USER=$2
        shift
        shift
        ;;
      -i|--ip)
        local _IP=$2
        shift
        shift
        ;;
      --interactive)
        local INTERACTIVE=1
        shift
        ;;
      *)
        break
        ;;
    esac
  done
  local INTERACTIVE=${INTERACTIVE:-0}
  if [[ $INTERACTIVE == 1 ]]; then
    echo 'Host: '
    read _HOST
    echo 'User: '
    read _USER
    echo 'IP Adress: '
    read _IP
  fi
  if [ -z $_HOST ]; then
    echo "Error: Host must be defined."
    kill -INT $$
  fi
  if [ -z $_USER ]; then
    echo "Error: User must be defined."
    kill -INT $$
  fi
  if [ -z $_IP ]; then
    echo "Error: IP Adress must be defined."
    kill -INT $$
  fi
  echo "" >> ~/.ssh/config
  echo "Host "$_HOST  >> ~/.ssh/config
  echo "  User "$_USER >> ~/.ssh/config
  echo "  Hostname "$_IP >> ~/.ssh/config
  echo "  ServerAliveInterval 30" >> ~/.ssh/config
  echo "  ServerAliveCountMax 120" >> ~/.ssh/config
  echo "SSH Host added succesfully!"
}

tm () {
  while test $# -gt 0; do
    case "$1" in
      -h|--help)
        echo "This is an executable to open a new tmux window with previously configured panes and "
        echo "windows, using the custom configuration."
        echo ""
        echo "Usage:"
        echo ">>> tm NAME"
        echo ""
        echo "If the defined NAME is a configuration on the ~/.teamocil folder, then that will be"
        echo "used. Else, a new TMUX session will be created with default initialization."
        echo ""
        echo "Args:"
        echo "NAME                      Name of the configuration to load."
        echo ""
        echo "Options:"
        echo "-h, --help                Show brief help."
        kill -INT $$
        ;;
      *)
        local NAME=$1
        shift
        ;;
    esac
  done

  local FILE=~/.teamocil/$NAME.yml
  local THEME_CONFIG_FILE=~/.tmux/tmux.$ZSH_THEME.conf
  local CONFIG_FILE=`echo $HOME/.tmux/tmux.conf`

  if [ -f "$THEME_CONFIG_FILE" ]; then
    export CONFIG_FILE=$THEME_CONFIG_FILE
  fi

  if [ -f "$FILE" ]; then
    tmux -f $CONFIG_FILE new -As -d "teamocil $NAME"\; attach
  else
    tmux -f $CONFIG_FILE new -As $NAME
  fi
}

# Custom autocompletes
compctl -g '~/.teamocil/*(:t:r)' teamocil
compctl -g '~/.teamocil/*(:t:r)' tm
compctl -g '~/.venvs/*(:t:r)' use
compctl -k "(--help --host --user --ip)" add_ssh_host

# Add git token for commodity (never commit it)
export GIT_TOKEN=

# Java stuff
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/jre
export PATH=$HOME/.maven/bin:$PATH

# GO path
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Multithreading issues
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Move words with option key
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# Alacritty and Vim colorschemes
chromance() {
  case "$1" in
    -h|help|--help)
      echo "Change colorscheme from both Alacritty and Vim."
      echo ""
      echo "In order for this to work you should add the 'chriskempson/base16-vim'"
      echo "plugin and add the following lines to your vimrc:"
      echo ""
      echo "if filereadable(expand(\"~/.vimrc_background\"))"
      echo "  let base16colorspace=256"
      echo "  source ~/.vimrc_background"
      echo "endif"
      echo ""
      echo ""
      echo "Commands:"
      echo "-h, help,--help           Show this help."
      echo "init                      Download colorschemes and requirements."
      echo "list                      Show list of available colorschemes."
      kill -INT $$
      ;;
    init)
      pip3 install alacritty-colorscheme
      mkdir ~/.chromance
      git clone \
        https://github.com/aaron-williamson/base16-alacritty.git \
        ~/.chromance
      echo "Ended initialization, don't forget to add the following to your vimrc."
      echo ""
      echo "if filereadable(expand(\"~/.vimrc_background\"))"
      echo "  let base16colorspace=256"
      echo "  source ~/.vimrc_background"
      echo "endif"
      kill -INT $$
      ;;
    list)
      ls ~/.vim/colors/base16-*.vim | sed -e 's@.*/base16-\(.*\)\.vim@\1@'
      kill -INT $$
      ;;
  esac

  if [ $# -eq 0 ]; then
    alacritty-colorscheme \
      -C ~/.chromance/colors \
      -c ~/.alacritty.yml \
      -s | sed -e 's@base16-\(.*\)\.yml@\1@'
  else
    alacritty-colorscheme \
      -C ~/.chromance/colors \
      -c ~/.alacritty.yml \
      -V \
      -a base16-$1.yml
  fi
}

_get_chromance_schemes() {
    reply=(init help list $(ls ~/.vim/colors/base16-$1*.vim | sed -e 's@.*/base16-\(.*\)\.vim@\1@'))
}
compctl -K _get_chromance_schemes chromance

repo() {
  # cd to repo folder.
  cd ~/git-repos/$1
}
compctl -g '~/git-repos/*(:t:r)' repo

alias gotosleep="sudo osascript -e 'tell application \"Finder\" to sleep'"
