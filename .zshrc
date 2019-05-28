# Created by newuser for 5.2
# If you come from bash you might have to change your $PATH.
export PATH=$PATH:/opt/android-sdk/platform-tools:~/.local/bin

# Path to your oh-my-zsh installation.
export ZSH=/home/svzieg/.oh-my-zsh

plugins=(git node npm archlinux systemd pj command-not-found autoenv colored-man-pages colorize)

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="sunrise"
TERM=xterm-256color

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="false"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(
#  git
#)

source $ZSH/oh-my-zsh.sh


export ANDROID_HOME=~/Android/Sdk
export GRADLE_HOME=/opt/android-studio/gradle/gradle-3.2

export EDITOR=vim
alias ssh_build='ssh developer@dev1.scheer-group.com -p2245'
alias mount_build='sudo sshfs -o allow_other,IdentityFile=/home/svzieg/.ssh/id_rsa,port=2245 developer@dev1.scheer-group.com:/home/developer /mnt/build/'

alias config='/usr/bin/git --git-dir=/home/svzieg/.cfg/ --work-tree=/home/svzieg'
compdef config='git'

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


export XKB_DEFAULT_LAYOUT=de,de
export XKB_DEFAULT_VARIANT=neo,nodeadkeys
export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle

# Native Wayland support
if [ $(tty) = "/dev/tty1" ]; then
	eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
	export SSH_AUTH_SOCK
	sway-neo
	exit 0
fi
alias dc="sudo docker-compose"
alias yarn=yarn --ignore-engines
###-begin-pm2-completion-###
### credits to npm for the completion file model
#
# Installation: pm2 completion >> ~/.bashrc  (or ~/.zshrc)
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _pm2_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           pm2 completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _pm2_completion pm2
elif type compctl &>/dev/null; then
  _pm2_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       pm2 completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _pm2_completion + -f + pm2
fi
###-end-pm2-completion-###
export PATH=/usr/bin/vendor_perl:$PATH
export PATH=~/.npm/bin:$PATH
export PATH=$PATH:~/.bin


bindkey '^R' history-incremental-search-backward


alias activate_anaconda="source /opt/anaconda/bin/activate root"
alias deactivate_anaconda="source /opt/anaconda/bin/deactivate root"

