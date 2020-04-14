#!/usr/bin/env fish

set -gx PATH /usr/bin/vendor_perl  /home/svzieg/.bin /home/svzieg/.yarn/bin  /home/svzieg/.local/bin ~/go/bin ~/.go/bin ~/.SpaceVim/bin  /usr/local/kubebuilder/bin/ $PATH 
set -gx EDITOR (which nvim)   

set -x GOPATH ~/.go
set -x GO111MODULE on



 alias config="git --git-dir=/home/svzieg/.cfg/ --work-tree=/home/svzieg"
 alias lg=lazygit



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



# if status is-interactive
# and not set -q TMUX
#     tmux
# end
