#!/bin/sh

SELF=$(cd $(dirname $0); pwd -P)/$(basename $0)
CONF=/etc/drizzle/drizzled.cnf
DRIZZLE=/usr/local/bin/drizzle
DAEMON=/usr/local/sbin/drizzled
DRIZZLE_USER=drizzle
DRIZZLE_GROUP=drizzle
LOG_DIR=/var/log/drizzle
LOG=${LOG_DIR}/drizzled.log
DEBUG=${LOG_DIR}/drizzled.debug

test -x ${DAEMON} || exit 0

[ -f /etc/default/drizzled ] && . /etc/default/drizzled

## Fetch a particular option from drizzle's invocation.
#
# Usage: void drizzled_get_param option
drizzled_get_param() {
	$DAEMON --help --user=${DRIZZLE_USER} \
    | grep "^$1" \
    | awk '{print $2}'
}

DATADIR=/var/lib/drizzle
PIDFILE=$DATADIR/`hostname -s`.pid

drizzled_status () {
    ping_output=`$DRIZZLE --ping 2>&1`; ping_alive=$(( ! $? ))

    ps_alive=0
    if [ -f "$PIDFILE" ] && ps `cat $PIDFILE` >/dev/null 2>&1; then ps_alive=1; fi
    
    if [ "$1" = "check_alive"  -a  $ping_alive = 1 ] ||
       [ "$1" = "check_dead"   -a  $ping_alive = 0  -a  $ps_alive = 0 ]; then
	return 0 # EXIT_SUCCESS
    else
  	if [ "$2" = "warn" ]; then
  	    echo -e "$ps_alive processes alive and '$DRIZZLE --ping' resulted in\n$ping_output\n" > $DEBUG
	fi
  	return 1 # EXIT_FAILURE
    fi
}

# Checks to see if something is already running on the port we want to use
check_protocol_port() {
    local service=$1

    port=`drizzled_get_param $1`

    if [ "x$port" != "x" ] ; then
        count=`netstat -l -n | grep \:$port | grep -c . `

        if [ $count -ne 0 ]; then
            echo "The selected $service port ($port) seems to be in use by another program "
            echo "Please select another port to use for $service"
            return 1
        fi
    fi
    return 0
}

case "${1:-''}" in
  'start')
    [ -e "${DATADIR}" ] || \
      install -d -o${DRIZZLE_USER} -g${DRIZZLE_USER} -m750 "${DATADIR}"
    # Start daemon
    echo "Starting Drizzle database server: drizzled"
    check_protocol_port mysql-protocol-port || exit 0
    check_protocol_port drizzle-protocol-port || exit 0
    start-stop-daemon --verbose --oknodo --background --chuid "$DRIZZLE_USER:$DRIZZLE_GROUP" --start --exec "$DAEMON" -- "--datadir=$DATADIR" > $LOG 2>&1
  ;;

  'stop')
    echo "Stopping Drizzle database server: drizzled"
    if [ -f "$PIDFILE" ]; then
        kill `cat $PIDFILE`
    fi
  ;;

  'restart'|'force-reload')
    $SELF stop
    sleep 1
    $SELF start
    ;;

  'status')
    if drizzled_status check_alive nowarn; then
      echo "Drizzle is alive."
      exit 0
    else
      echo "Drizzle is stopped."
      exit 1
    fi
    ;;

  *)
    echo "Usage: $SELF start|stop|restart|status"
    exit 1
  ;;

esac

exit 0
