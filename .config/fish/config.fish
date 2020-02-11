#!/usr/bin/env fish

set -gx PATH /home/svzieg/.bin /home/svzieg/bin /home/svzieg/.npm/bin $PATH 
set -gx EDITOR (which nvim)   



 alias config="git --git-dir=/home/svzieg/.cfg/ --work-tree=/home/svzieg"






# if status is-interactive
# and not set -q TMUX
#     tmux
# end
