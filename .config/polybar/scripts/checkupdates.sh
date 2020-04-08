#!/bin/sh
sleep $(fish -c "random 0 10" )
while pgrep -a "checkupdates 2> /dev/null"; do sleep 1; done

if ! updates=$(checkupdates 2> /dev/null | wc -l ); then
    updates=0
fi

if [ "$updates" -gt 0 ]; then
    echo "$updates"
else
    echo ""
fi
