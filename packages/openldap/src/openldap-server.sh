#!/bin/sh
#
# OpenLDAP server init script
#
# Sercan Arslan <arslanserc@gmail.com>
#

# Kill me on all errors
set -e

SERVICE="OpenLDAP Server"
SLAPD=/usr/local/libexec/slapd

# source default configuration
if [ -f "/usr/local/etc/default/openldap-server" ]; then
	. /usr/local/etc/default/openldap-server
fi

# Set the correct config option according to the configuration backend.
if [ -d "$SLAPD_CONF" ] ; then
	SLAPD_OPTIONS="-F $SLAPD_CONF $SLAPD_OPTIONS"
else
	SLAPD_OPTIONS="-f $SLAPD_CONF $SLAPD_OPTIONS"
fi

# Make sure the pidfile directory exists with correct permissions
piddir=`dirname "$SLAPD_PIDFILE"`
if [ ! -d "$piddir" ]; then
	mkdir -p "$piddir"
	[ -z "$SLAPD_USER" ] || chown -R "$SLAPD_USER" "$piddir"
	[ -z "$SLAPD_GROUP" ] || chgrp -R "$SLAPD_GROUP" "$piddir"
fi

# Pass the user and group to run under to slapd
if [ "$SLAPD_USER" ]; then
	SLAPD_OPTIONS="-u $SLAPD_USER $SLAPD_OPTIONS"
fi

if [ "$SLAPD_GROUP" ]; then
	SLAPD_OPTIONS="-g $SLAPD_GROUP $SLAPD_OPTIONS"
fi

# Check whether we were configured to not start the services.
check_for_no_start() {
	if [ -n "$SLAPD_NO_START" ]; then
		echo 'Not starting slapd: SLAPD_NO_START set in /usr/local/etc/default/openldap-server' >&2
		exit 0
	fi
}

start() {
	echo "Starting $SERVICE..."
	if [ -z "$SLAPD_SERVICES" ]; then
             start-stop-daemon --start --quiet --oknodo --pidfile "$SLAPD_PIDFILE" --exec $SLAPD -- $SLAPD_OPTIONS 2>&1
	else
             start-stop-daemon --start --quiet --oknodo --pidfile "$SLAPD_PIDFILE" --exec $SLAPD -- -h "$SLAPD_SERVICES" $SLAPD_OPTIONS 2>&1
	fi
}

stop() {
	echo "Stopping $SERVICE..."
	start-stop-daemon --stop --quiet --oknodo --retry TERM/10 --pidfile "$SLAPD_PIDFILE" --exec $SLAPD 2>&1
}

status() {
	 if [ -e $SLAPD_PIDFILE ]; then
              echo "$SERVICE is running."
              exit 0
         else
              echo "$SERVICE is not running."
              exit 1
         fi
}

case "$1" in
	start) check_for_no_start; start
		;;

	stop) stop
		;;

	restart) check_for_no_start; stop; sleep 1; start
		;;

	status) status
		;;

	*)
		echo "Usage: $0 {start|stop|restart|status}"
		exit 1
		;;
esac

