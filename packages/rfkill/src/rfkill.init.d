#!/bin/sh

. /usr/local/etc/conf.d/rfkill

case "$1" in
  start)
    for device in ${RFKILL_BLOCK}; do
      echo "Blocking rfkill device: ${device}"
      /usr/local/sbin/rfkill block ${device}
      if [ $? -eq 0 ]; then
        echo "done."
      else
        echo "failed!"
      fi
    done
    for device in ${RFKILL_UNBLOCK}; do
      echo "Unblocking rfkill device: ${device}"
      /usr/local/sbin/rfkill unblock ${device}
      if [ $? -eq 0 ]; then
        echo "done."
      else
        echo "failed!"
      fi
    done
    ;;
  stop)
    ;;
  restart)
    $0 start
    ;;
  *)
    echo "usage: $0 {start}"
    exit 1
    ;;
esac
exit 0
