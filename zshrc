export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="zeta"
ZSH_DISABLE_COMPFIX=true

HIST_STAMPS="yyyy-mm-dd"
plugins=(git autojump tmux macos colorize yarn jira extract)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"

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

# Docker
export DOCKER_DEFAULT_PLATFORM=linux/amd64
docker_start() {
  open --background -a Docker
}

color_list() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}

# SSL
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"

# LZ4
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/lz4/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/lz4/include"

# GeoIP
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/geoip/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/geoip/include"

copy_git_token() {
  cat ~/.credentials/github.token | pbcopy
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

autoload -Uz compinit
compinit
tm () {
  local opt
  opt=(-f "$HOME/.tmux/tmux.conf")

  case "$1" in
    -c)
      case "$2" in
        trainline)
          opt=(-f "$HOME/.tmux/tmux.trainline.conf")
          ;;
      esac
      shift 2
      ;;
  esac

  local session_name="$1"

  # Check if session_name is defined
  if [[ -z "$session_name" ]]; then
    echo "Error: session_name is not defined."
    return 1
  fi

  tmux "${opt[@]}" new-session -A -s "$session_name"
}
_tm_sessions() {
    # Use tmux to get a list of open sessions
    local sessions
    sessions=($(tmux list-sessions -F '#S' 2>/dev/null))

    # Set up completion based on the list of sessions
    compadd -a sessions
}
# Define your tm function
_tm() {
    local -a options

    # Define the options
    options=(
        '-c[Specify completion options]:completion options:(default trainline)'
    )

    # Set up completion for the -c option
    _arguments $options && return

    # If -c option is not specified, complete session_name
    _tm_sessions
}
# Add completion for the tm function
compdef _tm tm

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
#export GOROOT="$(brew --prefix golang)/libexec"
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
      pip3 install alacritty-colorscheme==1.0.0
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
      ls ~/.vim/bundle/base16-vim/colors/base16-$1*.vim | sed -e 's@.*/base16-\(.*\)\.vim@\1@'
      kill -INT $$
      ;;
  esac

  if [ $# -eq 0 ]; then
    alacritty-colorscheme \
      -C ~/.chromance/colors \
      -c ~/.alacritty.yml \
      status | sed -e 's@base16-\(.*\)\.yml@\1@'
  else
    alacritty-colorscheme \
      -C ~/.chromance/colors \
      -c ~/.alacritty.yml \
      -V \
      apply base16-$1.yml
  fi
}

_get_chromance_schemes() {
    reply=(init help list $(ls ~/.vim/bundle/base16-vim/colors/base16-$1*.vim | sed -e 's@.*/base16-\(.*\)\.vim@\1@'))
}
compctl -K _get_chromance_schemes chromance

repo() {
  # cd to repo folder.
  cd ~/git-repos/$1
}
compctl -g '~/git-repos/*(:t:r)' repo

alias gotosleep="sudo osascript -e 'tell application \"Finder\" to sleep'"

fix_pritunl() {
  sudo kill -9 $(ps aux | grep Pritunl | grep 'type=utility' | sed -E "s@[A-z]+ +([0-9]+) +.*@\1@")
}

# eval $(/opt/homebrew/bin/brew shellenv)
export PATH="/opt/homebrew/opt/libpq/bin:/Users/felipe/google-cloud-sdk/bin:$PATH"

json_encode() {
    python -c "import sys; import json; print(json.dumps(sys.stdin.read(), ensure_ascii=False))"
}
