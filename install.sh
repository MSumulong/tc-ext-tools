#!/bin/sh

############################################################################
#                                                                          #
#             install.sh: Installs tc-ext-tools to your system             #
#                                                                          #
############################################################################

#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#  Copyright (c) 2011 Sercan Arslan <arslanserc@gmail.com>
#

if [ ! -e .config ]; then
  echo "You need to create a user config file!"
  echo "See INSTALL for details."
  exit 1
else
  . .config
fi

[ -z "$DESTDIR" ] && DESTDIR=$HOME/.local

BINDIR=$DESTDIR/bin
SYSCONFDIR=$DESTDIR/etc
DATADIR=$DESTDIR/share

[ -d "$BINDIR" ] || install -m 755 -d $BINDIR

install -m 755 tools/* $BINDIR

install -D -m 644 default/build $DATADIR/tc-ext-tools/build
install -D -m 644 default/config $SYSCONFDIR/conf.d/tc-ext-tools.conf
install -D -m 755 default/functions $SYSCONFDIR/init.d/tc-ext-tools.sh
install -D -m 755 default/ashrc $SYSCONFDIR/init.d/tet-functions

sudo ln -sf $SYSCONFDIR/init.d/tet-functions /etc/init.d/tet-functions

# source tc-ext-tools shell environment functions in user's ashrc
if ! grep tet-functions ~/.ashrc >/dev/null; then
  if [ `id -u` = 0 ]; then
       su $USER -c "echo '. /etc/init.d/tet-functions' >> ~/.ashrc"
  else
       echo ". /etc/init.d/tet-functions" >> ~/.ashrc
  fi
fi

# add /etc/init.d/tet-functions to backup list
if ! grep tet-functions /opt/.filetool.lst >/dev/null; then
  if [ `id -u` = 0 ]; then
       su $USER -c "echo 'etc/init.d/tet-functions' >> /opt/.filetool.lst"
  else
       echo "etc/init.d/tet-functions" >> /opt/.filetool.lst
  fi
fi

install -D -m 644 -o $USER -g staff .config $HOME/.config/tc-ext-tools.conf

