#!/bin/sh

#
# grive daemon script by S. Arslan
# license: GPL
#

THIS=`basename $0`

if [ `id -u` == 0 ]
then
  echo "Do not execute $THIS as root!"
  exit 1
fi

GRIVE_FOLDER="$HOME/grive"
SYNC_INTERVAL=300

if [ -f "$HOME/.config/grived/grived.conf" ]
then
  . "$HOME/.config/grived/grived.conf"
fi

echo "Syncing google drive to $GRIVE_FOLDER"
echo "Make sure you have authenticated grive already."

echo "Entering infinite loop syncing every $SYNC_INTERVAL secs ..."
while [ /bin/true ]
do
  grive -p "$GRIVE_FOLDER"
  sleep $SYNC_INTERVAL
done
