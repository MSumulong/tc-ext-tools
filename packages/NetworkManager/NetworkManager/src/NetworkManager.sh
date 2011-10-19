#!/bin/sh
#
# Network Manager init script
#
# Sercan Arslan <arslanserc@gmail.com>
#

set -e

EXTENSION=$(basename $0)
SERVICE="Network Manager daemon"
NETWORKMANAGER=/usr/local/sbin/NetworkManager
PID_FILE=/var/run/NetworkManager.pid

# source default configuration
if [ -f /usr/local/etc/default/"$EXTENSION" ]; then
	. /usr/local/etc/default/"$EXTENSION"
fi

# Sanity checks.
[ -x $NETWORKMANAGER ] || exit 2

check_for_no_start() {
	if [ -n "$NETWORKMANAGER_NO_START" ]; then
		echo "Not starting $SERVICE: NO START is set in /usr/local/etc/default/$EXTENSION"
		exit 2
	fi
}

start() {
	if [ ! -e $PID_FILE ]; then
	     echo "Starting $SERVICE..."
	     if [ -z "$NETWORKMANAGER_OPTIONS" ]; then 
	          $NETWORKMANAGER
	     else
	          $NETWORKMANAGER $NETWORKMANAGER_OPTIONS
	     fi
	else
	     echo "$SERVICE is already running."
	     echo "If You are sure $SERVICE is not running, please manually remove $PID_FILE"
	fi
}

stop() {
	if [ -e $PID_FILE ]; then
	     echo "Stopping $SERVICE..."
	     kill $(cat ${PID_FILE})
	else
	     echo "$SERVICE is already not running."
	fi
}

status() {
	if [ -e $PID_FILE ]; then
	     echo "$SERVICE is running."
	     exit 0
	else
	     echo "$SERVICE is not running."
	     exit 1
	fi
}

case "$1" in
	start)
		check_for_no_start
		start
		;;
	stop)
		stop
		;;
	restart)
		check_for_no_start
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

