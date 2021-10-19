#!/bin/sh
swaynag -t warning -m \
        'You pressed the exit shortcut. What do you want?' \
        -b 'Logout' 'swaymsg exit' \
        -b 'Sleep' 'systemctl suspend' \
        -b 'Reboot' 'systemctl reboot' \
        -b 'Poweroff' 'systemctl poweroff'
