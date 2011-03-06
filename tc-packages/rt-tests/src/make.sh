#!/bin/sh

#
# rt-tests backfire kernel module build script
#
# by Sercan Arslan <arslanserc@gmail.com>
#

if [ -n "$CROSS_COMPILE" ]; then
   make CROSS_COMPILE="$CROSS_COMPILE" -C /lib/modules/`uname -r`/build M="$PWD" modules
else
   make -C /lib/modules/`uname -r`/build M="$PWD" modules
fi


