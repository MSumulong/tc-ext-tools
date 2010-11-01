#!/bin/sh
#
# KDE Display Manager init.d script
#
# Sercan Arslan <arslanserc@gmail.com>
#

. /etc/init.d/tc-functions

PID=$(pidof -o %PPID /usr/local/bin/kdm)

case "$1" in
  start)
    echo "${RED}Starting KDE Display Manager${NORMAL}"
    [ -z "$PID" ] && /usr/local/bin/kdm &>/dev/null
    if [ "$?" -gt 0 ]; then
      echo "failed!"
    else
      echo "success!"
    fi
    ;;
  stop)
    echo "${BLUE}Stopping KDE Display Manager${NORMAL}"
    [ ! -z "$PID" ]  && kill $PID &> /dev/null
    if [ "$?" -gt 0 ]; then
      echo "failed!"
    else
      echo "success!"
    fi
    ;;
  restart)
    $0 stop
    sleep 3
    $0 start
    ;;
  *)
    echo "usage: $0 {start|stop|restart}"
    ;;

esac
exit 0
