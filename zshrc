export ZSH=/Users/felipe/.oh-my-zsh

ZSH_THEME="bullet-train"

# Bullet Train Customizations
BULLETTRAIN_VIRTUALENV_FG=black
BULLETTRAIN_CUSTOM_BG=blue

BULLETTRAIN_GIT_BG=cyan
BULLETTRAIN_GIT_FG=black

BULLETTRAIN_CONTEXT_BG=white
BULLETTRAIN_CONTEXT_FG=black

BULLETTRAIN_TIME_BG=black
BULLETTRAIN_TIME_FG=green


HIST_STAMPS="yyyy-mm-dd"
plugins=(git syntax-highlighting enhancd autojump tmux)

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

export EDITOR=atom

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
alias rm='rm -v'
alias sudo='sudo ' # Expand aliases when using sudo
alias ssh='TERM=xterm-256color; ssh'
alias ds='du -shc * | sort -rh'
alias tm='tmux new -As felipe'

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

    # Start Tmux attaching to an existing session named fgon or creating one
    # with such name (we also indicate the tmux.conf file location)
    alias tm='tmux -f "$HOME/.tmux/tmux.conf" new -A -s fgon'

    # SSH and Tmux: connect to emr via ssh and then start tmux creating a new
    # session called pedrof or attaching to an existing one with that name.
    # Presto client
else
    # Differentiate and use colors for directories, symbolic links, etc.
    alias ls='ls -F --color=auto'
    # Change directory and list files
    cd() { builtin cd "$@" && ls -F --color=auto; }
    # Open tmux loading config file
    alias tm='tmux -f "$HOME/.tmux/tmux.conf" new -A -s fgon'
fi

# }}}
# Fzf {{{

if type "fzf" > /dev/null 2>&1; then
    # Enable completion and key bindings
    [[ $- == *i* ]] && . "$brew_dir/opt/fzf/shell/completion.bash" 2> /dev/null
    . "$brew_dir/opt/fzf/shell/key-bindings.bash"

    # Change default options (show 15 lines, use top-down layout)
    export FZF_DEFAULT_OPTS='--height 15 --reverse '\
'--bind=ctrl-space:toggle+down'
    # Use ag for files and fd for dirs
    export FZF_DEFAULT_COMMAND='ag -g ""'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    if type "tree" > /dev/null 2>&1; then
        export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
    fi
    # Disable tmux integration (use ncurses directly)
    export FZF_TMUX='0'

    # Alt-p mapping to cd to selected parent directory (sister to Alt-c)
    __fzf_cd_parent__() {
        local declare dirs=()
        get_parent_dirs() {
            if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
            if [[ "${1}" == '/' ]]; then
                for _dir in "${dirs[@]}"; do echo $_dir; done
            else
                get_parent_dirs $(dirname "$1")
            fi
    }
        local start_dir="$(dirname "$PWD")"  # start with parent dir
        local DIR=$(get_parent_dirs $(realpath "${1:-$start_dir}") | \
            fzf --preview 'tree -C -d -L 2 {} | head -200')
        if [[ ! -z $DIR ]]; then
            printf 'cd %q' "$DIR"
        else
            return 1
        fi
    }

    # Bookmarks (requires https://github.com/urbainvaes/fzf-marks)
    if [ -f "$brew_dir/opt/fzf/shell/fzf-marks.plugin.bash" ]; then
        . "$brew_dir/opt/fzf/shell/fzf-marks.plugin.bash"
        alias bm='fzm'
    fi

    # Z
    if [ -f "$brew_dir/etc/profile.d/z.sh" ]; then
        . /usr/local/etc/profile.d/z.sh
    fi
    unalias z 2> /dev/null
    z() {
        [ $# -gt 0 ] && _z "$*" && return
        cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse \
        --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
    }
    alias rd=z
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
        echo "-r, --requirements FILE   Specify requirements file to install."
        echo "--reset                   Erases current venv and sets up a new one"
        kill -INT $$
        ;;
      --reset)
        local RESET=1
        shift
        ;;
      -p|--python)
        local PYTHON="-p $2"
        shift
        shift
        ;;
      -r|--requirements)
        local REQUIREMENTS=$2
        shift
        shift
        ;;
      *)
        local NAME=$1
        shift
        ;;
    esac
  done
  local RESET=${RESET:-0}
  local REQUIREMENTS=${REQUIREMENTS:-requirements.txt}
  local _PATH=$HOME/.venvs/$NAME
  if [ $RESET = 1 ]; then
    echo "Reseting virtualenv..."
    rm -rf "$_PATH"
  fi
  if [ ! -d "$_PATH" ]; then
    virtualenv $_PATH $PYTHON
  fi
  source $_PATH/bin/activate
  if [ ! -d "$REQUIREMENTS" ]; then
    pip install -r $REQUIREMENTS
  fi
}

docker_start() {
  open --background -a Docker
}

color_list() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}
