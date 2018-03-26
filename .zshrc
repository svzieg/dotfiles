# Created by newuser for 5.2


export ANDROID_HOME=~/Android/Sdk

export PATH=$PATH:/home/svzieg/Android/Sdk:/home/svzieg/Android/Sdk/tools:/home/svzieg/Android/Sdk/platform-tools

export GRADLE_HOME=/opt/android-studio/gradle/gradle-3.2
source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_MODE='nerdfont-complete'


export EDITOR=nvim
alias ssh_build='ssh developer@dev1.scheer-group.com -p2245'
alias mount_build='sudo sshfs -o allow_other,IdentityFile=/home/svzieg/.ssh/id_rsa,port=2245 developer@dev1.scheer-group.com:/home/developer /mnt/build/'

alias config='/usr/bin/git --git-dir=/home/svzieg/.cfg/ --work-tree=/home/svzieg'
compdef config='git'
export SONAR_SCANNER_HOME="/opt/sonar-scanner"
export PATH="${PATH}:${SONAR_SCANNER_HOME}/bin"
