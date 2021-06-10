#!/usr/bin/env bash
if [ -z $WAYLAND_DISPLAY ]; then
  xsel -c -b 
  xsel -i -b
else
  wl-copy
fi
