

# Created by newuser for 5.2
# If you come from bash you might have to change your $PATH.
export PATH=$PATH:/home/svzieg/Android/Sdk:/home/svzieg/Android/Sdk/tools:/home/svzieg/Android/Sdk/platform-tools

# Path to your oh-my-zsh installation.
export ZSH=/home/svzieg/.oh-my-zsh

plugins=(git node npm archlinux systemd nyan pj command-not-found autoenv colored-man-pages colorize)

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

# If running trom tty1 start sway
if [ $(tty) = "/dev/tty1" ]; then
	sway
	exit 0
fi
