#!/bin/sh

conkeror=/usr/local/conkeror
xulrunner=/usr/local/bin/xulrunner

exec "$xulrunner" "$conkeror"/application.ini "$@"

