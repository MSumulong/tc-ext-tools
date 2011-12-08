#!/bin/sh
#
# OpenSLP server init script
#
# Sercan Arslan <arslanserc@gmail.com>
#

SERVICE="OpenSLP Server"
SLPD=/usr/local/sbin/slpd

# Sanity checks.
[ -x $SLPD ] || exit 2

# get PID of slpd
PID=`pidof -o %PPID $SLPD`

start() {
	if [ -z "$PID" ]; then
	     echo "Starting $SERVICE..."
             $SLPD
	else
	     echo "$SERVICE is already running."
	fi
}

stop() {
	if [ -n "$PID" ]; then
	     echo "Stopping $SERVICE..."
	     kill $PID
	else
	     echo "$SERVICE is not running."
	fi
}

status() {
	if [ -n "$PID" ]; then
	     echo "$SERVICE is running."
	     exit 0
	else
	     echo "$SERVICE is not running."
	     exit 1
	fi
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		sleep 1
		start
		;;
	status) 
		status
		;;
	*)
		echo "usage: $0 {start|stop|restart|status}"
		;;
esac
exit 0

