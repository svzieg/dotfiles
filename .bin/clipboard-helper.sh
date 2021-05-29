#!/usr/bin/env bash
if [ -z $WAYLAND_DISPLAY ]; then
  xsel -c 
  xsel -i -b
else
  wl-copy
fi
