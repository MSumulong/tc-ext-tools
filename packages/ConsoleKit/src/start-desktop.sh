#!/bin/sh
#
# Start Desktop Session with ConsoleKit
# 

CK_LAUNCH_SESSION=/usr/local/bin/ck-launch-session

if [ -z "$1" ]; then
  STARTUP=flwm_topside
else
  STARTUP="$1"
fi

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
     STARTUP="dbus-launch --exit-with-session $STARTUP"
fi

if [ -x "$CK_LAUNCH_SESSION" -a -z "$XDG_SESSION_COOKIE" ]; then
     STARTUP="$CK_LAUNCH_SESSION $STARTUP"
fi
