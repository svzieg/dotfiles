#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
  if (command -v $1 && ! pgrep $1); then
    $@ &
  fi
}

## run (only once) processes which spawn with different name
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
  gnome-keyring-daemon --daemonize --login &
fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
  start-pulseaudio-x11 &
fi
if (command -v /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 && ! pgrep polkit-gnome); then
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
fi

# causes high memory peaks?
# if (command -v xfce4-power-manager && ! pgrep xfce4-power-man); then
#   xfce4-power-manager &
# fi

if (command -v pulseeffects && ! pgrep pulseeffects); then
  pulseeffects --gapplication-service &
fi

run xfsettingsd
run nm-applet

run light-locker
run xcape -e 'Super_L=Super_L|Control_L|Escape'
run thunar --daemon
run pa-applet
run pamac-tray

## The following are not included in minimal edition by default
## but autorun.sh will pick them up if you install them

if (command -v system-config-printer-applet && ! pgrep applet.py); then
  system-config-printer-applet &
fi

run compton --shadow-exclude '!focused'
run blueman-applet
run msm_notifier

if [ -f ~/.screenlayout/default.sh ]; then
  ~/.screenlayout/default.sh &
fi

## for each output enable tearfree if possible
if (command -v awk && command -v xrandr); then
  xrandr --current | awk '/ connected/ { print "xrandr --output "$1" --set TearFree on" }' | sh &
fi
