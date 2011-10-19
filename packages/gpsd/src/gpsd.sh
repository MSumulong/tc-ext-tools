#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/sbin/gpsd
DESC="GPS (Global Positioning System) daemon"
SELF=$(cd $(dirname $0); pwd -P)/$(basename $0)

if [ -r /usr/local/etc/gpsd.rc ]; then
  . /usr/local/etc/gpsd.rc
else
  START_DAEMON="true"
  SOCKET="/var/run/gpsd.sock"
  PIDFILE="/var/run/gpsd.pid"  
fi

test -x $DAEMON || exit 0

case "$1" in
  start)
	if [ "x$START_DAEMON" = "xtrue" ] ; then
		echo "Starting $DESC gpsd"
		start-stop-daemon --start --quiet --exec $DAEMON -- $OPTIONS -F $SOCKET -P $PIDFILE $DEVICES
	else
		echo "Not starting $DESC gpsd"
	fi		
	;;
  stop)
	if [ "x$START_DAEMON" = "xtrue" ] ; then
		echo "Stopping $DESC gpsd"
		WARN=$(start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE)
		[ -n "$WARN" ] && echo "$WARN"
	else
		echo "Not stopping $DESC gpsd"
	fi		
	;;
  reload|force-reload)
	echo "gpsd: Resetting connection to GPS device" 
	WARN=$(start-stop-daemon --stop --signal 1 --quiet --oknodo --pidfile $PIDFILE)
	[ -n "$WARN" ] && echo "$WARN"
	;;
  restart)
	$SELF stop; $SELF start
	;;
  status)
	if [ -e /var/run/gpsd.pid ] ; then 
		echo "$DESC gpsd is running."
		exit 0
	else
		echo "$DESC gpsd is not running."
		exit 1
	fi
	;;
  *)
	echo "Usage: $0 {start|stop|restart|reload|force-reload|status}" >&2
	exit 1
	;;
esac

exit 0

