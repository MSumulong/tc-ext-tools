#!/bin/sh

# Dropbox wrapper script
# Sercan Arslan <arslanserc@gmail.com>

. /etc/init.d/tc-functions

DROPBOX=/usr/local/dropbox/dropboxd
PING="busybox ping"
HOST="www.dropbox.com"
NUMBER_OF_TRIES=60 # max ping count
WAIT_BETWEEN_TRIES=10 # seconds

start() {
echo "${YELLOW}Pinging to verify internet connection${NORMAL}"
echo "${RED}Press CTRL+C to cancel${NORMAL}"

while [ ${NUMBER_OF_TRIES} -gt 0 ]
do
	$PING -c 1 $HOST
	if [ $? = 0 ]; then
	     exec $DROPBOX $@
	     exit 0
	fi
	NUMBER_OF_TRIES=$(expr $NUMBER_OF_TRIES - 1)
	sleep $WAIT_BETWEEN_TRIES
done
}

force_start() {
shift
exec $DROPBOX $@
exit 0
}

case $1 in
  force) force_start ;;
  help)	echo "${YELLOW}Usage: $0 force|*=start|help${NORMAL}" ; exit 0 ;;
  *) start ;;
esac

# we shouldn't have come this far
exit 1

