#!/bin/sh

ATID_PID=`pidof -o %PPID /usr/local/sbin/atieventsd`

case "$1" in
  start)
    rc=0
    echo "Starting ATI Events Daemon"
    [ -z "$ATID_PID" ] && /usr/local/sbin/atieventsd
    rc=$(($rc+$?))
    if [ $rc -gt 0 ]; then
      echo "failed"
    else
      echo "successful"
    fi
    ;;
  stop)
    rc=0
    echo "Stopping ATI Events Daemon"
    kill $ATID_PID &>/dev/null
    rc=$(($rc+$?))
    if [ $rc -gt 0 ]; then
      echo "failed"
    else
      echo "successful"
    fi
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  status)
    if [ -z "$ATID_PID" ]; then
      echo "ATI Events Daemon is not running"
      exit 1
    else
      echo "ATI Events Daemon is running"
      exit 0
    fi
    ;;
  *)
    echo "usage: $0 {start|stop|restart|status}"  
esac
exit 0
