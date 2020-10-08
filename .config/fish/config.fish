#!/usr/bin/env fish

set -gx PATH /home/svzieg/.luarocks/bin /usr/bin/vendor_perl  /home/svzieg/.bin /home/svzieg/.yarn/bin /home/svzieg/.gem/ruby/2.7.0/bin /home/svzieg/.local/bin ~/go/bin ~/.go/bin ~/.krew/bin ~/.SpaceVim/bin ~/.garden/bin $PATH  /usr/local/kubebuilder/bin/ 
set -gx LUA_PATH '/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?/init.lua;/usr/lib/lua/5.3/?.lua;/usr/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua;/home/svzieg/.luarocks/share/lua/5.3/?.lua;/home/svzieg/.luarocks/share/lua/5.3/?/init.lua'
set -gx LUA_CPATH '/usr/lib/lua/5.3/?.so;/usr/lib/lua/5.3/loadall.so;./?.so;/home/svzieg/.luarocks/lib/lua/5.3/?.so'
set -gx EDITOR (which nvim)   

set -gx GOPATH ~/.go
set -gx GO111MODULE on



function config
  git --git-dir=/home/svzieg/.cfg/ --work-tree=/home/svzieg $argv[1..-1]
end 

function lg
 lazygit
end


function dockerv
  docker -H vagrantguest:2375 $argv[1..-1]
end


function defaultset --no-scope-shadowing
    if  test -n $argv[2]
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

