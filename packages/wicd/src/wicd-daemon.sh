#!/bin/sh
#
# Wicd daemon init script
#
# Sercan Arslan <arslanserc@gmail.com>
#

SERVICE="wicd daemon"
PIDFILE="/var/run/wicd/wicd.pid"

case "$1" in
  start)
    if [ -e "$PIDFILE" ]; then
      echo "$SERVICE appears to be running ."
      echo "If this is not the case, then remove "
      echo "$PIDFILE and try again..."
      exit 1
    else
      echo "Starting $SERVICE"
      /usr/local/sbin/wicd &> /dev/null
    fi
    ;;
  stop)
    echo "Stopping $SERVICE"
    pkill -f wicd-daemon.py &> /dev/null
    rm -f "$PIDFILE" 2>/dev/null
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  status)
    if [ -e "$PID_FILE" ]; then
      echo "$SERVICE is running."
      exit 0
    else
      echo "$SERVICE is not running."
      exit 1
    fi
    ;;
  *)
    echo "usage: $0 {start|stop|restart|status}"  
esac
exit 0
