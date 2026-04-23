# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
# NOTE: If things are broken I changed the single quotes to double.
xterm*|rxvt*)
    PS1='\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1'
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function pplay() {
    MUSIC_DIR="/home/cowboy/Documents/Music/background-noise/"
    if [ $TERM_PROGRAM = "tmux" ]; then
	tmux display-popup -E "exa ${MUSIC_DIR} | fzf --print0 > /tmp/music_popup" && \
	    TRACK_NAME=$(cat /tmp/music_popup) && \
	    if [ -z "$TRACK_NAME" ]; then
		    echo "Error: No track selected."
	    else
		    TRACK_PATH="${MUSIC_DIR}${TRACK_NAME}" && \
		    mpv --af=lavfi=[afade=t=in:ss=0:d=5] --loop "${TRACK_PATH}" $1;
	    fi
    else
	exa ${MUSIC_DIR} | fzf --print0 > /tmp/music_popup && \
	    TRACK_NAME=$(cat /tmp/music_popup) && \
	    if [ -z "$TRACK_NAME" ]; then
		    echo "Error: No track selected."
	    else
		    TRACK_PATH="${MUSIC_DIR}${TRACK_NAME}" && \
		    mpv --af=lavfi=[afade=t=in:ss=0:d=5] --loop "${TRACK_PATH}" $1;
	    fi
    fi
}

function image-size() {
    if [ $# -ne 1 ]; then
        echo "Usage: image-size <image>"
        return
    fi
    ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 $1
}

# $1: NUMBER, is the port to be killed 󰧻 🩸
function clean-port() {
  if [ $# -ne 1 ]; then
    echo "Usage: clean-port <port>"
    return
  fi
  cal port=$1
  local pid=$(lsof -ti :$port)

  if [ -z "$pid" ]; then
    echo "No process found using port $port"
  else
    kill -9 $pid
    if [ $? -eq 0 ]; then
      echo "Successfully killed process $pid using port $port"
    else
      echo "Failed to kill process $pid using port $port"
    fi
  fi
}

function create-video-from-image() {
  if [ $# -ne 2 ]; then
    echo "Usage: create-video-from-image <image> <duration>"
    return
  fi
  ffmpeg -loop 1 -i $1 -c:v libx264 -t $2 -pix_fmt yuv420p output.mp4
}

# function aplay() {
#   if [ "$#" -ne 2 ]; then
#     echo "Usage: aplay <audio_file> <volume>"
#     return
#   fi
#
#   TRACK=~/Documents/Videos/white-noise.mp3
#   VOLUME=50
#
#   if [ "$1" = "white-noise" ]; then
#     TRACK=~/Documents/Videos/white-noise.mp3
#   else
#     echo "not an audio file"
#     return
#   fi
#
#   if [ -n "$2" ]; then
#     VOLUME="$2"
#   fi
#
#   ffplay -volume "$VOLUME" -nodisp -autoexit "$TRACK"
# }
# -------

function randArrayElement () {
    arr=("${!1}");
    return ${arr["$[RANDOM % ${#arr[@]}]"]};
}

function help_command() {
    echo "ipython | ipython3 in vim mode";
    echo "reload | source .bashrc";
    echo "play_ambiences | Give args to play sound";
    echo "               | random - Plays a random ambient sound";
    echo "               | thunder - Plays a random thunder.";
    echo "               | thunder1";
    echo "               | thunder2";
    echo "               | thunder3";
    echo "               | minecraft";
}

function gitswap() {
    if [ $# -eq 0 ]; then
        echo "Input Required";
        return;
    elif [ $1 == "cowboy" ]; then
        git config user.name cowboy8625
        git config user.email cowboy8625@yahoo.com
    elif [ $1 == "codex" ]; then
        git config user.name dailycodex
        git config user.email codex-live@yahoo.com
    else
        echo "Unknonw Option ${$1}";
    fi
}

function char_count() {
    if [ $# -eq 0 ]; then
        echo "File type needed";
        echo "examples: lines *.rs";
    else
        find . -name "*.${1}" -print0 | wc --files0-from=- -c;
        # ( find ./ -name $1 -print0 | xargs -0 cat ) | wc -l;
    fi
}

function timer() {
    termtime -f mono12 -m "Be Back in $1" -F 0,139,139
}

function timer-with-message() {
    termtime -f mono12 -m "$1" -F 0,139,139
}

function edit-nvim() {
  START=$PWD;
  cd ~/dotfiles/.config/nvim ; nvim init.lua ; cd $START;
}

function edit-emacs() {
  START=$PWD;
  cd ~/.config/emacs ; nvim config.org ; cd $START;
}

function edit-bash() {
  START=$PWD;
  cd ~/dotfiles ; nvim .bashrc ; cd $START;
}

function going-live() {
    echo ":red_square: **Going Live on Twitch** <https://twitch.tv/dailycodex> **Topic**: $1 @Live Ping" | xclip -selection c
}

function spawn () {
    tmux new-session -d -s spawn -n session-list;
    tmux choose-session
    tmux attach -t spawn
}

function javavm() {
    if [[ "$#" -ne 1 ]]; then
        echo "Usage: $0 <java version>"
        return 1
    fi

    if [[ "$1" -ne 11 ]] && [[ "$1" -ne 17 ]] && [[ "$1" -ne 21 ]] && [[ "$1" -ne 23 ]]; then
        echo "Java version not supported."
        echo "Supported versions are: 11, 17, 21 and 23."
        return 1
    fi

    sudo update-alternatives --set java /usr/lib/jvm/java-$1-openjdk-amd64/bin/java;
    export JAVA_HOME=/usr/lib/jvm/java-$1-openjdk-amd64/bin/;
    export PATH=$PATH:$JAVA_HOME;
}

alias ipython="ipython3 --TerminalInteractiveShell.editing_mode=vi";
alias reload="source ~/.bashrc"; #  && echo reloaded;";
alias config="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME";
alias mcfile="cd /home/cowboy/.var/app/com.mojang.Minecraft/data/minecraft";
alias irust="evcxr";
alias python="python3";
alias ls="exa --icons";
alias lang="cd ~/Documents/Rust/languages";
alias rust="cd ~/Documents/Rust";
alias update="sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo apt clean && sudo apt autoclean && snap refresh && flatpak update && rustup update";
alias cook="cd ~/Documents/CookBook";
alias pword="nvim ~/Documents/cnffjbeqf.md";
alias :q="exit";
alias vlc="vlc --sout-all --sout \"#duplicate{dst=display}\"";
alias mirror="xrandr --output DP-4 --same-as HDMI-0";
alias mirror-off="xrandr --output DP-4 --right-of HDMI-0";
alias get-image-dim="ffmpeg -i image.jpg 2>&1 | grep 'Stream' | grep -oP '\d+x\d+'";
alias svim="NVIM_APPNAME=suckless-neovim nvim";
alias nnvim="NVIM_APPNAME=new-nvim-0.12.0 nvim";
alias ovim="NVIM_APPNAME=obsidian-neovim nvim";


# Set Editor
export EDITOR='nvim';
# Setting Pager to bat;
export PAGER="bat -p";
# Key Binding Mode;
set -o vi;
bind -m vi-command 'Control-l: clear-screen';
bind -m vi-insert 'Control-l: clear-screen';

eval "$(starship init bash)";
source "$HOME/.cargo/env";

export DOTNET_ROOT=$HOME/.dotnet
export DENO_INSTALL="/home/cowboy/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
export PATH="$HOME/.local/bin/clang+llvm-18.1.8-x86_64-linux-gnu-ubuntu-18.04/bin:$PATH"
export PATH="$HOME/Aur/Odin:$PATH"

[ -f "/home/cowboy/.ghcup/env" ] && source "/home/cowboy/.ghcup/env"; # ghcup-env

source /home/cowboy/.config/broot/launcher/bash/br
source ~/.zoxiderc
source ~/.envrc

# Wasmer
export WASMER_DIR="/home/cowboy/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

export PICO_SDK_PATH=/home/cowboy/Aur/picotool/build/pico/pico-sdk
export PICO_EXAMPLES_PATH=/home/cowboy/Aur/picotool/build/pico/pico-examples
export PICO_EXTRAS_PATH=/home/cowboy/Aur/picotool/build/pico/pico-extras
export PICO_PLAYGROUND_PATH=/home/cowboy/Aur/picotool/build/pico/pico-playground

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

# nu && exit

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -s "${HOME}/.g/env" ] && \. "${HOME}/.g/env"  # g shell setup

# Check if the alias 'g' exists before trying to unalias it
if [[ -n $(alias g 2>/dev/null) ]]; then
    unalias g
fi
export ANDROID_HOME=/opt/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export EMSDK=/home/cowboy/Aur/emsdk
export EMSDK_NODE=/home/cowboy/Aur/emsdk/node/20.18.0_64bit/bin/node
export EMSDK_QUIET=1
export PATH="$HOME/Aur/Odin:$PATH"
export DB_URL_REDSTONECODE_LOCAL=postgresql://redstonecode:redstonecode@192.168.1.147:9999/redstonecode
export DB_URL_REDSTONECODE_PROD=postgresql://redstonecode:123456@192.168.1.147:9999/redstonecode
export DB_URL_SNOW_BOT=postgresql://snow-bot:snow-bot@localhost:9999/snow-bot
export DB_URL_DBVI_LOCAL=postgresql://postgres:postgres@localhost:5444/postgres
export PATH="$HOME/scripts:$PATH";

# Elixir
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

dotnet=/bin/dotnet

# ENV
if [ -f "$HOME/.config/secrets/env" ]; then
  source "$HOME/.config/secrets/env"
fi
