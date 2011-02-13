#!/bin/sh

conkeror=/usr/local/conkeror
xulrunner=/usr/local/bin/xulrunner

if [ -x "$xulrunner" ]; then
     exec "$xulrunner" "$conkeror"/application.ini "$@"
fi

