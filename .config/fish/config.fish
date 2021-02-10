#!/usr/bin/env fish

set -gx PATH /home/svzieg/.luarocks/bin /usr/bin/vendor_perl /home/svzieg/.bin /home/svzieg/.yarn/bin /home/svzieg/.gem/ruby/2.7.0/bin /home/svzieg/.local/bin ~/go/bin ~/.krew/bin ~/.SpaceVim/bin ~/.garden/bin $PATH /usr/local/kubebuilder/bin/
set -gx LUA_PATH '/home/svzieg/.luarocks/share/lua/5.3/?.lua;/home/svzieg/.luarocks/share/lua/5.3/?/init.lua;;'
set -gx LUA_CPATH '/usr/lib/lua/5.3/loadall.so;./?.so;/home/svzieg/.luarocks/lib/lua/5.3/?.so;;'
set -gx EDITOR (which nvim)

set -gx GOPATH ~/go
set -gx GO111MODULE on

kitty + complete setup fish | source


function config
    git --git-dir=/home/svzieg/.cfg/ --work-tree=/home/svzieg $argv[1..-1]
end

function lg
    lazygit
end


function ssh
    kitty +kitten ssh $argv[1..-1]
end

function dockerv
    docker -H vagrantguest:2375 $argv[1..-1]
end


function defaultset --no-scope-shadowing
    if test -n $argv[2]
        set $argv[1] $argv[2]
    else
        set $argv[1] $argv[3..-1]
    end
end


# Jira shortcuts 
function track_dev_time
    defaultset time_spend $argv[1] "8h"
    defaultset comment $argv[2] "."
    defaultset ticket $argv[3] "EED-173"

    echo "jira worklog add --noedit $ticket -T $time_spend -m $comment $argv[4..-1]"
    jira worklog add --noedit $ticket -T $time_spend -m $comment $argv[4..-1]

end


function backup_home
    sudo rsync -aAxv ~/ --exclude={".config/gnome-boxes/", "*.iso",  ".npm", ".config/libvirt/", "coding/vagrant-boxes/*/.vagrant/", ".vagrant.d/", ".config", ".cache", ".local"} $argv[1..-1]
end


function fish_mode_prompt --description 'Displays the current mode'
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        switch $fish_bind_mode
            case default
                set_color --bold red
                echo 🅽
            case insert
                set_color --bold green
                echo 🅸
            case replace-one
                set_color --bold green
                echo 🆁
            case visual
                set_color --bold brmagenta
                echo 🆅
        end
        set_color normal
        printf " "
    end
end



function nvim_build_scripts
    set cwd (pwd)
    cd_nvim_plugin_dir opt

    # typescript-nvim 
    cd nvim-typescript
    ./install.sh
    cd ..

    cd deoplete-go
    make
    cd ..

    cd $cwd
end

function nvim_list_plugins
    ls /home/svzieg/.local/share/nvim/site/pack/git-plugins/*/
end


function cd_nvim_plugin_dir
    mkdir -p /home/svzieg/.local/share/nvim/site/pack/git-plugins/$argv[1]
    cd /home/svzieg/.local/share/nvim/site/pack/git-plugins/$argv[1]
end


function nvim_mv_plugin
    if test "$argv[1]" != "" && test "$argv[2]" != "" && test "$argv[3]" != ""
        set cwd (pwd)
        cd_nvim_plugin_dir $argv[1]
        cd $argv[3]
        set upstreamURL (git remote get-url origin)
        cd $cwd

        if test "$upstreamURL" != ""
            config rm -f /home/svzieg/.local/share/nvim/site/pack/git-plugins/$argv[1]/$argv[3]

            if test "$argv[2]" = "start"
                nvim_add_start_plugin $upstreamURL
            else
                nvim_add_opt_plugin $upstreamURL
            end
        end
    else
        echo "cannot delete root directory, you have to speciy a plugin"
    end
end

function nvim_rm_start_plugin
    if test "$argv[1]" != ""
        config rm -f /home/svzieg/.local/share/nvim/site/pack/git-plugins/start/$argv[1]
    else
        echo "cannot delete root directory, you have to speciy a plugin"
    end
end


function nvim_rm_opt_plugin
    if test "$argv[1]" != ""
        config rm -f /home/svzieg/.local/share/nvim/site/pack/git-plugins/opt/$argv[1]
    else
        echo "cannot delete root directory, you have to speciy a plugin"
    end
end

function nvim_add_opt_plugin
    echo "add new opt Plugin: $argv[1]"
    set cwd (pwd)
    cd_nvim_plugin_dir opt
    if test "$argv[2]" != ""
        config submodule add --branch $argv[2] $argv[1]
    else
        config submodule add $argv[1]
    end
    cd $cwd
end

function nvim_add_start_plugin
    echo "add new start Plugin: $argv[1]"
    set cwd (pwd)
    cd_nvim_plugin_dir start
    if test "$argv[2]" != ""
        config submodule add --branch $argv[2] $argv[1]
    else
        config submodule add $argv[1]
    end
    cd $cwd
end


# Kubernetes aliases

alias k kubectl
alias kd 'k describe'
alias kg 'k get'
alias kgyaml 'k get -o yaml'
alias kgyml 'k get -o yaml'
alias kaf 'k apply -f'
alias kdel 'k delete'
alias ke 'k edit'
alias kccc 'k config current-context'
alias kcdc 'k config delete-context'
alias kcsc 'k config set-context'
alias kcuc 'k config use-context'
alias kdd 'kd deployment'
alias kdeld 'kdel deployment'
alias kdeli 'kdel ingress'
alias kdelp 'kdel pods'
alias kdels 'kdel svc'
alias kdelsec 'kdel secret'
alias kdi 'kd ingress'
alias kdp 'kd pods'
alias kds 'kd svc'
alias kdsec 'kd secret'
alias ked 'ke deployment'
alias kei 'ke ingress'
alias kep 'ke pods'
alias kes 'ke svc'
alias keti 'k exec -ti'
alias kgd 'kg deployment'
alias kgi 'kg ingress'
alias kgp 'kg pods'
alias kgrs 'kg rs'
alias kgs 'kg svc'
alias kgsec 'kg secret'
alias kl 'k logs'
alias klf 'k logs -f'
alias krh 'k rollout history'
alias krsd 'k rollout status deployment'
alias kru 'k rollout undo'
alias kr 'k rollout restart'
alias ksd 'k scale deployment'
starship init fish | source
