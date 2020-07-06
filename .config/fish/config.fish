#!/usr/bin/env fish

set -gx PATH /usr/bin/vendor_perl  /home/svzieg/.bin /home/svzieg/.yarn/bin /home/svzieg/.gem/ruby/2.7.0/bin /home/svzieg/.local/bin ~/go/bin ~/.go/bin ~/.SpaceVim/bin  $PATH  /usr/local/kubebuilder/bin/
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
export LUA_PATH='/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?/init.lua;/usr/lib/lua/5.3/?.lua;/usr/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua;/home/svzieg/.luarocks/share/lua/5.3/?.lua;/home/svzieg/.luarocks/share/lua/5.3/?/init.lua'
export LUA_CPATH='/usr/lib/lua/5.3/?.so;/usr/lib/lua/5.3/loadall.so;./?.so;/home/svzieg/.luarocks/lib/lua/5.3/?.so'
export PATH='/home/svzieg/.luarocks/bin:/usr/bin/vendor_perl:/home/svzieg/.bin:/home/svzieg/.yarn/bin:/home/svzieg/.local/bin:/home/svzieg/go/bin:/home/svzieg/.go/bin:/home/svzieg/.SpaceVim/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/core_perl:/usr/local/kubebuilder/bin/'
