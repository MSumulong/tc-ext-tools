#!/bin/sh

MURMURD=/usr/local/sbin/murmurd
CONF=/usr/local/etc/conf.d/murmur

. /etc/init.d/tc-functions

[ -f $CONF ] && . $CONF

PID=$(pidof -o %PPID $MURMURD)
case "$1" in
  start)
    echo -e "\nStarting murmur ... \c"

    [ -z "$PID" ] && $MURMURD $PARAMS
    if [ $? -gt 0 ]; then
      echo -e "failed!\n"
    else
      echo -e "ok!\n"
    fi
    ;;
  stop)
    echo -e "\nStopping murmur ... \c"
    [ ! -z "$PID" ]  && kill $PID &> /dev/null
    if [ $? -gt 0 ]; then
      echo -e "failed!\n"
    else
      echo -e "ok!\n"
    fi
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  status)
    if [ -z "$PID" ]; then
      echo -e "\nmurmur is not running\n"
      exit 1
    else
      echo -e "\nmurmur is running\n"
      exit 0
    fi
    ;;
  *)
    echo "usage: $0 {start|stop|restart|status}"
esac
exit 0
