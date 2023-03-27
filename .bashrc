# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTSIZE=
export HISTFILESIZE=
export HISTFILE=~/.bash_eternal_history
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="&:ls:ll:h:history:[bf]g:exit:kill:pwd:clear:mount:umount:histoclean"
# Force prompt to write history after every command http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

histoclean() {
  # Remove dups
  awk -i inplace '!x[$0]++' "${HISTFILE}"
  # Remove silly commands
  sed -i '/^cat .*/d; 
    /^ls$/d;
    /^cd .*/d;
    /^h$/d;
    /^h .*/d;
    /^popd$/d;
    /^kill .*/d;
    /^sudo kill .*/d;
    /^sudo reboot$/d;
    /^rm .*/d;
    /^sudo rm .*/d;
    /^history .*/d;
    /^histoclean$/d;
    s/^[ \t]*//g;
    /^exit$/d' "${HISTFILE}"
  # Remove invalid commands
  local tmp_bash_history
  tmp_bash_history=$(mktemp -p. tmp_bash_history.XXXXXXXX)
  trap '[[ -f ${tmp_bash_history} ]] && rm -f -- "${tmp_bash_history}"' EXIT
  # Iterate over each line in the bash history file and remove the lines that contain an invalid command
  while read -r line; do
    # Extract the first word of the line as the command
    command=$(echo "$line" | awk '{print $1}')
    # Check if the command exists and is executable
    if command -v "$command" >/dev/null 2>&1; then
      echo "$line"
    fi
  done < "${HISTFILE}" > "${tmp_bash_history}"
  # Replace the original bash history file with the temporary history file
  mv "${tmp_bash_history}" "${HISTFILE}"
}

# shellcheck disable=SC2120
history() {
  # https://unix.stackexchange.com/a/48116
  builtin history -a
  HISTFILESIZE=$HISTSIZE
  builtin history -c
  builtin history -r
  builtin history "$@"
}

histogrep() {
  if [ -z "$1" ]; then 
    history
  else
    history | grep "$@"
  fi
}
alias h=histogrep


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
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
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

if [ -f "$HOME"/.bash_aliases ]; then
    source "$HOME"/.bash_aliases
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

alias gitlog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

findstring() {
	if [ -z "$1" ]; then
		echo "Err. Need something to search for"
	else
		grep -rnw '.' -e "$1"
	fi
}
alias f=findstring

# https://unix.stackexchange.com/questions/90853/how-can-i-run-ssh-add-automatically-without-password-prompt
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval $(ssh-agent -s)
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

# https://rockportnetworks.atlassian.net/wiki/spaces/EN/pages/1770979761/Configure+access+to+Artifactory
pass version &>/dev/null && export ARTI_USER=$(whoami) ARTI_PWD=$(pass show artifactory)

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

GOVERSION=1.20.2
GOPATH="/opt/local/${USER}/go"
[[ ! -d "$GOPATH" ]] && echo "ERROR: Missing $GOPATH directory. Create this directory and give privs to $USER."
[[ -d "$GOPATH" ]] && export GOPATH
GOSDK="$GOPATH/sdk"
# Make sure /home/user/sdk is a symlink to /opt/local/user/go/sdk
[[ -d "$HOME/sdk" && ! -L "$HOME/sdk" ]] && mv "$HOME/sdk" "$GOSDK"
[[ ! -d "$HOME/sdk" ]] && ln -s "$GOSDK" "$HOME/sdk"
# Install desired Go version if not already present
if [[ ! -f "$GOSDK/go$GOVERSION/bin/go" ]]; then 
  export GOROOT="/usr/local/go" 
  /usr/local/go/bin/go install "golang.org/dl/go$GOVERSION@latest"
  "/opt/local/$USER/sdk/go${GOVERSION}" download
fi
# Set some env vars
GOROOT="$GOSDK/go$GOVERSION"
[[ -d "$GOROOT" ]] && export GOROOT
GOMODCACHE="$GOROOT/pkg/mod"
mkdir -p "$GOMODCACHE"
[[ -d "$GOMODCACHE" ]] && export GOMODCACHE
# Adjust PATH env var
[[ -d "$GOROOT/bin" && $PATH != *"$GOROOT/bin"* ]] && export PATH="$GOROOT/bin:$PATH"

XDG_CACHE_HOME="/opt/local/${USER}/.cache"; export XDG_CACHE_HOME
