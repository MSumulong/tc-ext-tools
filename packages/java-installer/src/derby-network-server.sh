#!/bin/sh

. /etc/profile.d/jdk.sh
. $DERBY_HOME/bin/derby_common.sh

DAEMON_NAME="derby-network-server"
DAEMON_CONF="/usr/local/etc/conf.d/$DAEMON_NAME"
DAEMON_PID="/var/run/$DAEMON_NAME.pid"

[ -f $DAEMON_CONF ] && . $DAEMON_CONF

DERBY_START_CMD="$JAVACMD $DERBY_OPTS -classpath \"$LOCALCLASSPATH\" org.apache.derby.drda.NetworkServerControl start"
DERBY_STOP_CMD="$JAVACMD $DERBY_OPTS -classpath \"$LOCALCLASSPATH\" org.apache.derby.drda.NetworkServerControl shutdown"

case "$1" in
  start)
    echo "Starting Derby Network Server"
    $DERBY_START_CMD > /dev/null &

    PID=`ps ax | grep -v grep | grep derby | grep org.apache.derby.drda.NetworkServerControl | awk '{print $1}'`
      
    if [ -z "$PID" ]; then
        echo "failed!"
    else
        echo $PID > $DAEMON_PID
        sleep 2
        echo "done."
    fi
    ;;
  stop)
    echo "Stopping Derby Network Server"

    $DERBY_STOP_CMD > /dev/null &

    if [ $? -gt 0 ]; then
        echo "failed!"
    else
        rm -f $DAEMON_PID
        echo "done."
    fi
    ;;
  restart)
    $0 stop
    sleep 5
    $0 start
    ;;
  status)
    if [ -e "$DAEMON_PID" ]; then
        echo "Running."
        exit 0
    else
        echo "Not running."
        exit 1
    fi
    ;;
  *)
    echo "usage: $0 {start|stop|restart|status}"
esac
exit 0

