#!/bin/bash
 
# Fix resolution bug

#xrandr --output eDP1 --mode 1920x1080 --primary


# Load resources
 
xrdb -merge .Xresources
 
# Set up an icon tray
 
trayer --edge top --align right --SetDockType true --SetPartialStrut true  --expand true --width 10 --transparent true --alpha 1 --tint 0x000000 --height 19 &

# Start compton

compton --config .compton.conf &


# Set the background color<
 
xsetroot -solid midnightblue
 
# Fire up apps
 
# ~/.xmonad/scripts/wallpaper.sh &

gajim &

thunderbird &

owncloud &

xscreensaver -no-splash &
 
if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi
 
if [ -x /usr/bin/gnome-power-manager ] ; then
   sleep 3
   gnome-power-manager &
fi
 
# exec xmonad
