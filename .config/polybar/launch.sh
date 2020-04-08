#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done


# Launch polybar on multiple screens
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    # Launch bar1 and bar2
    MONITOR=$m polybar top -c ~/.config/polybar/config-top.ini &
    MONITOR=$m polybar bottom -c ~/.config/polybar/config-bottom.ini &
  done
else
  polybar top -c ~/.config/polybar/config-top.ini &
  polybar bottom -c ~/.config/polybar/config-bottom.ini &
fi

echo "Bars launched..."
