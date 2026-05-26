# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/svzieg/.zsh/completions:"* ]]; then export FPATH="/home/svzieg/.zsh/completions:$FPATH"; fi

if [[ ":$FPATH:" != *":/home/linuxbrew/.linuxbrew/share/zsh/site-functions:"* ]]; then export FPATH="/home/linuxbrew/.linuxbrew/share/zsh/site-functions:$FPATH"; fi


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="crcandy"

plugins=( 
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh


# check the dnf plugins commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dnf


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/folders in terminal using eza
if which eza > /dev/null; then
  alias ls='eza -a --icons'
  alias ll='eza -al --icons'
  alias lt='eza -a --tree --level=1 --icons'
fi

alias nx='nice npx nx'
#alias devcontainer='nice npx --package=devcontainers/cli -- devcontainer'
alias yalc='nice npx yalc'
#alias nvim='mise use node@24 && nice $(which nvim)'
alias dive='nice docker run --rm -it -v /home/svzieg/.docker:/root/.docker:ro -v /var/run/docker.sock:/var/run/docker.sock  wagoodman/dive:latest'
Dive() {
  docker pull $1 && dive $1
}



# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


#kubectx and kubens
export PATH=~/.kubectx:~/.local/bin/:$PATH
export EDITOR="nvim"

# mongodb
export MONGOMS_ARCH=x64
export MONGOMS_PLATFORM=linux
export MONGOMS_DISTRO=rhel-9


export GITLAB_HOST=https://gitlab.scheer-group.com

# pasctl completions
if which pasctl > /dev/null 2>&1; then source <(pasctl completion zsh); fi
if which k0sctl > /dev/null 2>&1; then source <(k0sctl completion); fi  
if which flux > /dev/null 2>&1; then source <(flux completion zsh); fi


# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit

# use default node version on shell spawn
#if [[ -f .nvmrc ]]; then fnm use --silent-if-unchanged; fi 
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"; fi

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/var/home/svzieg/.lmstudio/bin"
# End of LM Studio CLI section

