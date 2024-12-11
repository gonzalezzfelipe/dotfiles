export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true

HIST_STAMPS="yyyy-mm-dd"
plugins=(git autojump macos colorize yarn extract)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"

zstyle ':omz:alpha:lib:git' async-prompt no  # https://github.com/ohmyzsh/ohmyzsh/issues/12267
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

# Terraform
alias tf="terraform"  # No more terrafrom

# Other binaries
if type "htop" > /dev/null 2>&1; then
    alias ht='htop'
fi
if type "bat" > /dev/null 2>&1; then
    # Colorized cat
    alias dog='bat --style numbers --theme TwoDark'
fi

if type "lsd" > /dev/null 2>&1; then
    alias ls='lsd'
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

# GO path
export GOPATH="${HOME}/.go"
#export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Multithreading issues
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Move words with option key
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

_get_chromance_schemes() {
    reply=(init help list $(ls ~/.vim/bundle/base16-vim/colors/base16-$1*.vim | sed -e 's@.*/base16-\(.*\)\.vim@\1@'))
}
compctl -K _get_chromance_schemes chromance

alias gotosleep="sudo osascript -e 'tell application \"Finder\" to sleep'"

# eval $(/opt/homebrew/bin/brew shellenv)
export PATH="/opt/homebrew/opt/libpq/bin:/Users/felipe/google-cloud-sdk/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"  # Rust

json_encode() {
    python -c "import sys; import json; print(json.dumps(sys.stdin.read(), ensure_ascii=False))"
}

# K9s
export K9S_CONFIG_DIR="$HOME/.config/k9s"

# Zoxide
eval "$(zoxide init zsh --cmd cd)"

# NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$PATH:/Users/felipe/.dmtr/bin"

eval "$(starship init zsh)" 
eval "$(mcfly init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/felipe/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/felipe/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/felipe/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/felipe/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

. "$HOME/.cargo/env"
