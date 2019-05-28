export XKB_DEFAULT_LAYOUT=de,de
export XKB_DEFAULT_VARIANT=neo,nodeadkeys
export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle


if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export JAVA_FONTS=/usr/share/fonts/TTF
export EDITOR=nvim

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano PKGBUILD'
alias fixit='sudo rm -f /var/lib/pacman/db.lck'
alias update='yaourt -Syua'
alias con='nano $HOME/.i3/config'
alias comp='nano $HOME/.config/compton.conf'
alias inst='sudo pacman -S'
alias mirrors='sudo pacman-mirrors -g'
alias db='sudo pacman -Syy'
alias printer='system-config-printer'

alias ssh_build='ssh developer@dev1.scheer-group.com -p2245'
alias mount_build='sudo sshfs -o allow_other,IdentityFile=/home/svzieg/.ssh/id_rsa,port=2245 developer@dev1.scheer-group.com:/home/developer /mnt/build/'

export PATH=$PATH:~/.gem/ruby/2.4.0/bin:/usr/lib/ruby/gems/2.4.0:/home/svzieg/.gem/ruby/2.4.0

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# prompt
PS1='[\u@\h \W]\$ '
alias config='/usr/bin/git --git-dir=/home/svzieg/.cfg/ --work-tree=/home/svzieg'
alias config='/usr/bin/git --git-dir=/home/svzieg/.cfg/ --work-tree=/home/svzieg'
export SONAR_SCANNER_HOME="/opt/sonar-scanner"
export PATH="${PATH}:${SONAR_SCANNER_HOME}/bin"

# If running trom tty1 start sway
if [ $(tty) == "/dev/tty1" ]; then
	sway-de-neo2
	exit 0
fi
export PATH=/usr/bin/vendor_perl:$PATH
export PATH=~/.npm/bin:$PATH
export PATH=$PATH:~/.bin


set -o vi
